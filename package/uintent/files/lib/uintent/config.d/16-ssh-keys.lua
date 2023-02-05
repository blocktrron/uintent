#!/usr/bin/lua

local util = require("uintent.util")

local profile = util.get_profile()

if not util.table_contains_key(profile, "ssh-keys") then
    return
end

os.execute("mkdir -p /etc/dropbear")

local f = io.open("/etc/dropbear/authorized_keys", "w")

for _, v in ipairs(profile["ssh-keys"]) do
    f:write(v, "\n")
end

f:close()
