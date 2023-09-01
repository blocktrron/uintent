#!/usr/bin/lua

local uci = require("uintent.simple-uci").cursor()
local util = require("uintent.util")

local interface = util.get_uplink_interface()

uci:section("lldpd", "lldpd", "config", { interface = interface })

uci:commit("lldpd")
