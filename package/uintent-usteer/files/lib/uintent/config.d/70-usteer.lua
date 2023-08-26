#!/usr/bin/lua

local uci = require("uintent.simple-uci").cursor()
local util = require("uintent.util")

local profile = util.get_profile()

uci:delete_all("usteer", "usteer")

if not util.table_contains_key(profile, "usteer") then
	return
end

for section_name, usteer_config in pairs(profile["usteer"]) do
	uci:section("usteer", "usteer", section_name, {})

	-- TODO: i would like it to generate this value via the `"networks"."lan"."usteer"="USTEER-SECTION-NAME`
	if util.table_contains_key(usteer_config, "network") then
		uci:set("usteer", section_name, "network", usteer_config["network"])
	else
		print("ERROR: usteer network must be set")
		os.exit(1)
	end
	if util.table_contains_key(usteer_config, "syslog") then
		uci:set("usteer", section_name, "syslog", usteer_config["syslog"])
	else
		uci:set("usteer", section_name, "syslog", "1")
	end
	if util.table_contains_key(usteer_config, "local_mode") then
		uci:set("usteer", section_name, "local_mode", usteer_config["local_mode"])
	else
		uci:set("usteer", section_name, "local_mode", "0")
	end
	if util.table_contains_key(usteer_config, "ipv6") then
		uci:set("usteer", section_name, "ipv6", usteer_config["ipv6"])
	else
		uci:set("usteer", section_name, "ipv6", "1")
	end
	if util.table_contains_key(usteer_config, "debug_level") then
		uci:set("usteer", section_name, "debug_level", usteer_config["debug_level"])
	else
		uci:set("usteer", section_name, "debug_level", 2)
	end
	if util.table_contains_key(usteer_config, "max_neighbor_reports") then
		uci:set("usteer", section_name, "max_neighbor_reports", usteer_config["max_neighbor_reports"])
	end
	if util.table_contains_key(usteer_config, "sta_block_timeout") then
		uci:set("usteer", section_name, "sta_block_timeout", usteer_config["sta_block_timeout"])
	end
	if util.table_contains_key(usteer_config, "local_sta_timeout") then
		uci:set("usteer", section_name, "local_sta_timeout", usteer_config["local_sta_timeout"])
	end
	if util.table_contains_key(usteer_config, "measurement_report_timeout") then
		uci:set("usteer", section_name, "measurement_report_timeout", usteer_config["measurement_report_timeout"])
	end
	if util.table_contains_key(usteer_config, "local_sta_update") then
		uci:set("usteer", section_name, "local_sta_update", usteer_config["local_sta_update"])
	end
	if util.table_contains_key(usteer_config, "max_retry_band") then
		uci:set("usteer", section_name, "max_retry_band", usteer_config["max_retry_band"])
	end
	if util.table_contains_key(usteer_config, "seen_policy_timeout") then
		uci:set("usteer", section_name, "seen_policy_timeout", usteer_config["seen_policy_timeout"])
	end
	if util.table_contains_key(usteer_config, "load_balancing_threshold") then
		uci:set("usteer", section_name, "load_balancing_threshold", usteer_config["load_balancing_threshold"])
	end
	if util.table_contains_key(usteer_config, "band_steering_threshold") then
		uci:set("usteer", section_name, "band_steering_threshold", usteer_config["band_steering_threshold"])
	end
	if util.table_contains_key(usteer_config, "remote_update_interval") then
		uci:set("usteer", section_name, "remote_update_interval", usteer_config["remote_update_interval"])
	end
	if util.table_contains_key(usteer_config, "remote_node_timeout") then
		uci:set("usteer", section_name, "remote_node_timeout", usteer_config["remote_node_timeout"])
	end
	if util.table_contains_key(usteer_config, "assoc_steering") then
		uci:set("usteer", section_name, "assoc_steering", usteer_config["assoc_steering"])
	end
	if util.table_contains_key(usteer_config, "probe_steering") then
		uci:set("usteer", section_name, "probe_steering", usteer_config["probe_steering"])
	end
	if util.table_contains_key(usteer_config, "min_connect_snr") then
		uci:set("usteer", section_name, "min_connect_snr", usteer_config["min_connect_snr"])
	end
	if util.table_contains_key(usteer_config, "min_snr") then
		uci:set("usteer", section_name, "min_snr", usteer_config["min_snr"])
	end
	if util.table_contains_key(usteer_config, "min_snr_kick_delay") then
		uci:set("usteer", section_name, "min_snr_kick_delay", usteer_config["min_snr_kick_delay"])
	end
	if util.table_contains_key(usteer_config, "steer_reject_timeout") then
		uci:set("usteer", section_name, "steer_reject_timeout", usteer_config["steer_reject_timeout"])
	end
	if util.table_contains_key(usteer_config, "roam_process_timeout") then
		uci:set("usteer", section_name, "roam_process_timeout", usteer_config["roam_process_timeout"])
	end
	if util.table_contains_key(usteer_config, "roam_scan_snr") then
		uci:set("usteer", section_name, "roam_scan_snr", usteer_config["roam_scan_snr"])
	end
	if util.table_contains_key(usteer_config, "roam_scan_tries") then
		uci:set("usteer", section_name, "roam_scan_tries", usteer_config["roam_scan_tries"])
	end
	if util.table_contains_key(usteer_config, "roam_scan_timeout") then
		uci:set("usteer", section_name, "roam_scan_timeout", usteer_config["roam_scan_timeout"])
	end
	if util.table_contains_key(usteer_config, "roam_scan_interval") then
		uci:set("usteer", section_name, "roam_scan_interval", usteer_config["roam_scan_interval"])
	end
	if util.table_contains_key(usteer_config, "roam_trigger_snr") then
		uci:set("usteer", section_name, "roam_trigger_snr", usteer_config["roam_trigger_snr"])
	end
	if util.table_contains_key(usteer_config, "roam_trigger_interval") then
		uci:set("usteer", section_name, "roam_trigger_interval", usteer_config["roam_trigger_interval"])
	end
	if util.table_contains_key(usteer_config, "roam_kick_delay") then
		uci:set("usteer", section_name, "roam_kick_delay", usteer_config["roam_kick_delay"])
	end
	if util.table_contains_key(usteer_config, "signal_diff_threshold") then
		uci:set("usteer", section_name, "signal_diff_threshold", usteer_config["signal_diff_threshold"])
	end
	if util.table_contains_key(usteer_config, "initial_connect_delay") then
		uci:set("usteer", section_name, "initial_connect_delay", usteer_config["initial_connect_delay"])
	end
	if util.table_contains_key(usteer_config, "load_kick_enabled") then
		uci:set("usteer", section_name, "load_kick_enabled", usteer_config["load_kick_enabled"])
	end
	if util.table_contains_key(usteer_config, "load_kick_threshold") then
		uci:set("usteer", section_name, "load_kick_threshold", usteer_config["load_kick_threshold"])
	end
	if util.table_contains_key(usteer_config, "load_kick_delay") then
		uci:set("usteer", section_name, "load_kick_delay", usteer_config["load_kick_delay"])
	end
	if util.table_contains_key(usteer_config, "load_kick_min_clients") then
		uci:set("usteer", section_name, "load_kick_min_clients", usteer_config["load_kick_min_clients"])
	end
	if util.table_contains_key(usteer_config, "load_kick_reason_code") then
		uci:set("usteer", section_name, "load_kick_reason_code", usteer_config["load_kick_reason_code"])
	end
	if util.table_contains_key(usteer_config, "band_steering_interval") then
		uci:set("usteer", section_name, "band_steering_interval", usteer_config["band_steering_interval"])
	end
	if util.table_contains_key(usteer_config, "band_steering_min_snr") then
		uci:set("usteer", section_name, "band_steering_min_snr", usteer_config["band_steering_min_snr"])
	end
	if util.table_contains_key(usteer_config, "link_measurement_interval") then
		uci:set("usteer", section_name, "link_measurement_interval", usteer_config["link_measurement_interval"])
	end
	if util.table_contains_key(usteer_config, "node_up_script") then
		uci:set("usteer", section_name, "node_up_script", usteer_config["node_up_script"])
	end
	if util.table_contains_key(usteer_config, "event_log_types") then
		uci:set_list("usteer", section_name, "event_log_types", usteer_config["event_log_types"])
	end
	-- TODO: i would like it to
	-- generate this via `wireless"."BAND"."networks"."NetworkName"."usteer"="USTEER-SECTION-NAME` parameters
	if util.table_contains_key(usteer_config, "ssid_list") then
		uci:set_list("usteer", section_name, "ssid_list", usteer_config["ssid_list"])
	end
end

uci:commit("usteer")
