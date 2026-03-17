-- Needs Project Title v3.7+

local userpatch = require("userpatch")

local patched = false
local function patchCoverBrowser(plugin)
    if patched then return end
    patched = true

    local util = require("util")
    local ptutil = require("ptutil")

    local base = G_reader_settings:readSetting("home_dir"):match("(.*)/.*/?$") -- HOME/..
    local images = base .. "/.images/" -- HOME/../.images/
    local ext = ".png"

    local function fileIfExists(path)
        return util.fileExists(path) and path
    end

    function ptutil.findCover(dir_path)
        if not dir_path or dir_path == "" or dir_path == ".." or dir_path:match("%.%.$") then
            return nil
        end

        dir_path = dir_path:gsub("/+$", "")
        if not util.directoryExists(dir_path) then return nil end

        local folder = dir_path:match("^" .. base .. "/(.*)$")
        if not folder then return nil end

        local mode = G_reader_settings:readSetting("night_mode") and "_dark" or "_light"
        local icon = images .. folder .. "/folder"
        return fileIfExists(icon .. mode .. ext) or fileIfExists(icon .. ext)
    end
end

userpatch.registerPatchPluginFunc("coverbrowser", patchCoverBrowser)
