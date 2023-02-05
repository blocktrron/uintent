#!/usr/bin/lua

local uci = require("uintent.simple-uci").cursor()
local util = require("uintent.util")

local profile = util.get_profile()

uci:set("system", uci:get_first("system", "system"), "hostname", profile["hostname"])
uci:commit("system")
