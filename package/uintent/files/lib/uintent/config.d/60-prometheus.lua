#!/usr/bin/lua

local uci = require("uintent.simple-uci").cursor()

uci:set("prometheus-node-exporter-lua", "main", "listen_interface", "*")

uci:commit("prometheus-node-exporter-lua")
