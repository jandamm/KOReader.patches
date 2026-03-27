-- Needs Project Title v3.7+

local userpatch = require("userpatch")

local function patchCoverBrowser(plugin)
    local has_pt, ptutil = pcall(require, "ptutil")
    if not has_pt or ptutil._jd_patched_folder_icons then return end
    ptutil._jd_patched_folder_icons = true

    local util = require("util")

    local base = G_reader_settings:readSetting("home_dir"):match("(.*)/.*/?$") -- HOME/..
    local folder_icons = base .. "/.folder_icons/" -- HOME/../.folder_icons/
    local ext = ".jpg"

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
        local icon = folder_icons .. folder .. "/folder"
        return fileIfExists(icon .. mode .. ext) or fileIfExists(icon .. ext)
    end
end

userpatch.registerPatchPluginFunc("coverbrowser", patchCoverBrowser)
