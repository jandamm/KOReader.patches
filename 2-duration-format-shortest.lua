#!/usr/bin/env lua

local datetime = require("datetime")

--[[
This patch shows a compact date format:
When the time interval is < 1 hour -> 1:23
When the time interval is > 1 hour -> 1:23h

So it will always match '%d{1,2}:%d{2}' (except when > 1d and the caller wants days separated.)

You can set show_minutes_unit to append "m" when the interval is < 1 hour.
--]]

-- Show 0:03m for 3s instead of 0:03
local show_minutes_unit = false


local original = datetime.secondsToClockDuration
function datetime.secondsToClockDuration(format, seconds, withoutSeconds, withDays, compact)
    local value = original("classic", seconds, seconds >= 3600, withDays, false)

    if withDays and seconds >= 86400 then
        return value:gsub("^(%d+d)0(%d:)", "%1%2") -- remove leading hours 0
    end
    if seconds >= 3600 then
        return value:gsub("^0(%d:)", "%1") .. "h" -- remove leading hours 0
    end
    -- Remove hours and leading minutes 0
    return value:gsub("^00?:", ''):gsub("^0(%d:)", "%1") .. (show_minutes_unit and "m" or "")
end

