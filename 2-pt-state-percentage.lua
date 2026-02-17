-- Needs Project Title v3.7+

local userpatch = require("userpatch")

local orig_progress = nil
local function patchCoverBrowser(plugin)
    local ptutil = require("ptutil")

    if orig_progress == nil then
        orig_progress = ptutil.formatProgressText
    end
    function ptutil.formatProgressText(status, bookinfo, pages, draw_progressbar, percent_finished, progress_strings)
        local progress_str, percent_str, pages_str, pages_left_str = orig_progress(status, bookinfo, pages, draw_progressbar, percent_finished, progress_strings)

        if draw_progressbar and status ~= 'complete' and percent_finished then
            progress_str = progress_str .. ': ' .. math.floor(100 * percent_finished) .. "%"
        end

        return progress_str, percent_str, pages_str, pages_left_str
    end
end

userpatch.registerPatchPluginFunc("coverbrowser", patchCoverBrowser)
