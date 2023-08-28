local unistd = require("posix.unistd")
local dirent = require("posix.dirent")

local function find_phy_by_path(path)
	local device_path, phy_offset = string.match(path, "^(.+)%+(%d+)$")

	-- Special handling required for multi-phy devices
	if device_path == nil then
		device_path = path
		phy_offset = "0"
	end

	-- Find the device path. Either it's located at /sys/devices or /sys/devices/platform
	local path_prefix = ""
	if not unistd.access("/sys/devices/" .. device_path .. "/ieee80211") then
		path_prefix = "platform/"
	end

	-- Get all available PHYs of the device and dertermine the one with the lowest index
	local phy_names = dirent.dir("/sys/devices/" .. path_prefix .. device_path .. "/ieee80211")
	local device_phy_idxs = {}
	for _, v in ipairs(phy_names) do
		local phy_idx = v:match("^phy(%d+)$")

		if phy_idx ~= nil then
			table.insert(device_phy_idxs, tonumber(phy_idx))
		end
	end

	table.sort(device_phy_idxs)

	-- Index starts at 1
	return "phy" .. device_phy_idxs[tonumber(phy_offset) + 1]
end

local M = {}

function M.find_phy(radio)
	return find_phy_by_path(radio)
end

return M
