local datetime = require("datetime")

local always_compact = false

local original_secondsToClock = datetime.secondsToClockDuration
datetime.secondsToClockDuration = function (format, seconds, withoutSeconds, withDays, compact)
    local out = original_secondsToClock(format, seconds, withoutSeconds, withDays, compact)
    if format == "classic" and (compact or always_compact) then
        return out:gsub("^0(%d:)", "%1")
    end
    return out
end

