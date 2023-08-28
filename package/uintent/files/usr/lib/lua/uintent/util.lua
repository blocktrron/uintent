local cjson = require("cjson")

local M = {}

function M.trim(str)
	return str:gsub("^%s*(.-)%s*$", "%1")
end

local function readall(f)
	if not f then
		return nil
	end

	local data = f:read("*a")
	f:close()
	return data
end

function M.exec(command)
	return readall(io.popen(command))
end

function M.get_primary_mac()
	local mac = M.exec("/usr/lib/uintent/label_mac.sh")

	if mac == nil then
		return nil
	end

	mac = M.trim(mac)
	if string.len(mac) ~= 17 then
		return nil
	end

	return mac
end

function M.read_profile_from_file(name)
	local f = io.open("/lib/uintent/config/profile/" .. name .. ".json", "r")
	if f == nil then
		return nil
	end
	local content = f:read("*all")
	f:close()
	return cjson.decode(content)
end

function M.merge_table(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" and type(t1[k] or false) == "table" then
			M.merge_table(t1[k] or {}, t2[k] or {})
		else
			t1[k] = v
		end
	end

	return t1
end

function M.get_profile()
	local global_profile = M.read_profile_from_file("global")
	local device_profile = M.read_profile_from_file(string.gsub(M.get_primary_mac(), ":", ""))

	if device_profile == nil then
		return global_profile
	end

	return M.merge_table(global_profile, device_profile)
end

function M.table_contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function M.table_contains_key(table, table_key)
	return table[table_key] ~= nil
end

function M.get_uplink_interface()
	--luacheck: ignore 512
	for line in io.lines("/lib/uintent/board/uplink_port") do
		return line
	end
	return nil
end

return M
