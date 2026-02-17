--[[
This user patch is for use with the Project: Title plugin.
It requires v3.5.

The Patch allows you to modify the maximum progress bar width.

By default, Project: Title limits progress bars to 235 pixels maximum,
which represents 705 pages (at 3 pages per pixel). For books longer
than this the progress bar is cut off and shows a "large book" indicator '∫'.

This patch modifies the limit to allow for longer or shorter progress bars.
You might have to play around with it to find a value that fits your screen (width and dpi).

Author: Andreas Lösel
License: GNU AGPL v3
--]]

-- Modified by me to fit the Kobo Claras screen size.
-- Should be working fine with 5-6 items per page.
-- Source: https://github.com/loeffner/KOReader.patches/blob/main/project-title/2-pt-modify-progressbar-max-width.lua

local userpatch = require("userpatch")

local function patchCoverBrowser(plugin)
    local ptutil = require("ptutil")

    -- This value will make the progress bar "physically" longer. If there is not enough space it will squish the elements on the left.
    ptutil.list_defaults.progress_bar_max_size = 430
    -- This value squeezes more pages into the same space, making the bar reflect larger books without increasing the physical size.
    ptutil.list_defaults.progress_bar_pages_per_pixel = 3
end

userpatch.registerPatchPluginFunc("coverbrowser", patchCoverBrowser)
