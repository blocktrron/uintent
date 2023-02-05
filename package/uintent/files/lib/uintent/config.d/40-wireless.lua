#!/usr/bin/lua

local uci = require("uintent.simple-uci").cursor()
local iwinfo = require 'iwinfo'

local util = require("uintent.util")
local wireless = require("uintent.wireless")

local profile = util.get_profile()

uci:delete_all("wireless", "wifi-iface")

local function determine_htmode(radio, band_config)
	local phy = wireless.find_phy(radio["path"])
	if phy == nil then
		return "HT20"
	end

	local bandwith = "20"
	if util.table_contains_key(band_config, "bandwith") then
		bandwith = tostring(band_config["bandwith"])
	end

	if iwinfo.nl80211.hwmodelist(phy).ax then
		return 'HE' .. bandwith
	end

	if iwinfo.nl80211.hwmodelist(phy).ac then
		return 'VHT' .. bandwith
	end

	return "HT" .. bandwith
end

local function create_vifs(radio, vifs)
	local radio_id = radio:match('^radio(%d+)$')

	for name, vif in pairs(vifs) do
		local vif_config = {}
		local ifname = "ap" .. radio_id .. "_" .. name
		local network_name = vif["network"] .. "_dummy"

		vif_config["device"] = radio
		vif_config["ifname"] = ifname
		vif_config["ssid"] = vif["ssid"]
		vif_config["network"] = network_name
		vif_config["mode"] = "ap"

		if util.table_contains_key(vif, "security") then
			-- Key Management
			if vif["security"]["type"] == "WPA2-PSK" then
				vif_config["encryption"] = "psk2"
				vif_config["key"] = vif["security"]["password"]
			elseif vif["security"]["type"] == "WPA2-EAP-TTLS-PAP" then
				vif_config["encryption"] = "wpa2"
				vif_config["server"] = vif["security"]["radius"]["server"]
				vif_config["key"] = vif["security"]["radius"]["key"]
				vif_config["eap_type"] = "ttls"
				vif_config["auth"] = "pap"
			elseif vif["security"]["type"] == "OWE" then
				vif_config["encryption"] = "owe"

				-- Check if we need to create a unencrypted companion network
				if util.table_contains_key(vif["security"], "transition_ssid") then
					local open_vif_ifname = ifname .. "_ue"
					local owe_vif_ifname = ifname
					vif_config["hidden"] = 1
					vif_config["ssid"] = vif["security"]["transition_ssid"]
					vif_config["ifname"] = owe_vif_ifname

					-- Create unencrypted companion network
					vif_config["owe_transition_ifname"] = open_vif_ifname
					uci:section("wireless", "wifi-iface", open_vif_ifname, {
						device = radio,
						ifname = open_vif_ifname,
						ssid = vif["ssid"],
						encryption = "none",
						mode = "ap",
						network = network_name,
						owe_transition_ifname = owe_vif_ifname
					})
				end
			end

			-- Management Frame Protection
			if util.table_contains_key(vif["security"], "mfp") then
				vif_config["ieee80211w"] = vif["security"]["mfp"]
			end
		else
			vif_config["encryption"] = "none"
		end

		uci:section("wireless", "wifi-iface", vif_config["ifname"], vif_config)
	end
end

local function channel_config(name, band_config)
	-- Default to ACS
	uci:set("wireless", name, "channel", "0")

	-- Always set channel if set
	if util.table_contains_key(band_config, "channel") then
		uci:set("wireless", name, "channel", band_config["channel"])
	end

	-- Check if channel-list is defined
	if util.table_contains_key(band_config, "channel-list") then
		local channel_list = band_config["channel-list"]
		local chanlist = ""
		local acs_bias = ""

		for chan, priority in pairs(channel_list) do
			local sep = " "
			if string.len(chanlist) == 0 then
				sep = ""
			end

			chanlist = chan .. sep .. chanlist
			acs_bias = chan .. ":" .. priority .. sep .. acs_bias
		end

		uci:set("wireless", name, "channels", chanlist)
		uci:set("wireless", name, "acs_chan_bias", acs_bias)
		uci:delete("wireless", name, "channel")
	end
end

uci:foreach("wireless", "wifi-device", function(radio)
	local name = radio[".name"]
	local band = radio["band"]
	local band_config

	uci:set("wireless", name, "disabled", 0)
	uci:set("wireless", name, "country", "DE")

	if band == "2g" then
		band_config = profile["wireless"]["2g"]
	elseif band == "5g" then
		band_config = profile["wireless"]["5g"]
	end

	channel_config(name, band_config)
	uci:set("wireless", name, "htmode", determine_htmode(radio, band_config))
	uci:set("wireless", name, "legacy_rates", 0)

	if band_config["outdoor"] == true then
		uci:set("wireless", name, "country3", "0x4f")
	end

	create_vifs(name, band_config["networks"])
end)

uci:commit("wireless")
