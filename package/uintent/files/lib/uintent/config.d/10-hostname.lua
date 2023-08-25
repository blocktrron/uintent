#!/usr/bin/lua

local uci = require("uintent.simple-uci").cursor()
local util = require("uintent.util")

local profile = util.get_profile()

local hostname = profile["hostname"]

-- replace placeholders
hostname = string.gsub(hostname, "{mac}", string.gsub(util.get_primary_mac(), ":", ""))

uci:set("system", uci:get_first("system", "system"), "hostname", hostname)
uci:commit("system")
