-- Needs Project Title v3.7+

local userpatch = require("userpatch")

local patched = false
local function patchCoverBrowser(plugin)
    if patched then return end
    patched = true

    local util = require("util")
    local ptutil = require("ptutil")

    local function fileIfExists(path)
        return util.fileExists(path) and path
    end

    function ptutil.findCover(dir_path)
        if not dir_path or dir_path == "" or dir_path == ".." or dir_path:match("%.%.$") then
            return nil
        end

        dir_path = dir_path:gsub("[/\\]+$", "")
        if not util.directoryExists(dir_path) then return nil end

        local mode = G_reader_settings:readSetting("night_mode") and "dark" or "light"
        return fileIfExists(dir_path .. "/.folder_" .. mode .. ".png") or fileIfExists(dir_path .. "/.folder.png")
    end
end

userpatch.registerPatchPluginFunc("coverbrowser", patchCoverBrowser)
