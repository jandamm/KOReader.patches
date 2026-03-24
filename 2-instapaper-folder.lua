-- Patch for: https://github.com/omer-faruq/instapaper.koplugin

local userpatch = require("userpatch")

local function patchCoverBrowser(Instapaper)
    local lfs = require("libs/libkoreader-lfs")
    local util = require("util")
    local cache = {}

    function Instapaper:getDownloadDir()
        local home_dir = G_reader_settings:readSetting("home_dir")
        if cache.dir and cache.home_dir == home_dir then
            return cache.dir
        end
        local parent_dir, _ = util.splitFilePathName(home_dir:gsub("/$", ""))
        local dir = parent_dir .. "Instapaper"
        lfs.mkdir(dir)
        cache.dir = dir
        cache.home_dir = home_dir
        return dir
    end
end

userpatch.registerPatchPluginFunc("instapaper", patchCoverBrowser)
