#!/usr/bin/lua

local uci = require("uintent.simple-uci").cursor()
local util = require("uintent.util")

local interface = util.get_uplink_interface()
local profile = util.get_profile()

-- remove default network bridge
uci:delete("network", "lan")
uci:delete("network", "wan")
uci:delete("network", "wan6")

uci:delete_all("network", "device")
uci:delete_all("network", "interface")

for ifname, network in pairs(profile["networks"]) do
	local bridge_name = "br-" .. ifname
	local port_name = interface

	if util.table_contains_key(network, "vlan") then
		port_name = interface .. "." .. network["vlan"]
	end

	uci:section("network", "device", ifname, {
		name = bridge_name,
		type = "bridge",
		ports = { port_name },
	})

	-- Add dummy interface to create bridge
	uci:section("network", "interface", ifname .. "_dummy", {
		ifname = bridge_name,
		proto = "none",
	})

	if util.table_contains_key(network, "ip4") then
		for name, address_config in pairs(network["ip4"]) do
			local section_name = ifname .. "_" .. name .. "_4"
			local proto = address_config["type"]

			uci:section("network", "interface", section_name, {
				ifname = bridge_name,
				proto = proto,
			})

			if proto == "static" then
				uci:set("network", section_name, "ipaddr", address_config["address"])
				if util.table_contains_key(address_config, "gateway") then
					uci:set("network", section_name, "gateway", address_config["gateway"])
				end
				uci:set("network", section_name, "netmask", address_config["netmask"])
			end
		end
	end
end

uci:commit("network")
