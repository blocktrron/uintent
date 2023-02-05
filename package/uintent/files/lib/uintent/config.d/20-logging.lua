#!/usr/bin/lua

local uci = require("uintent.simple-uci").cursor()
local util = require("uintent.util")

local profile = util.get_profile()

if not util.table_contains_key(profile, "remote_syslog") then
    return
end

local syslog_settings = profile["remote_syslog"]

local system = uci:get_first("system", "system")
uci:set("system", system, "log_remote", 1)
uci:set("system", system, "log_ip", syslog_settings["ip"])
uci:set("system", system, "log_port", syslog_settings["port"])
uci:set("system", system, "log_proto", syslog_settings["proto"])

uci:commit("system")
