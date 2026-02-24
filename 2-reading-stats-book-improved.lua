local DataStorage = require("datastorage")
local SQ3 = require("lua-ljsqlite3/init")
local datetime = require("datetime")
local ffiUtil = require("ffi/util")
local _ = require("gettext")

local N_ = _.ngettext
local T = ffiUtil.template

local userpatch = require("userpatch")

-- Inspired by https://github.com/omer-faruq/koreader-user-patches/blob/main/2-reading-stats-current-book-days-percent.lua
-- and https://github.com/koreader/koreader/blob/6d86891d9262026cc52be756a5b19b6e580fb33d/plugins/statistics.koplugin/main.lua#L2249

local function padLeft(s, len, bef, aft)
    local space = "\226\128\135" -- U+2007 Figure Space (UTF-8 Bytes)
    return string.rep(space, len - #s) .. (bef or '') .. s .. (aft or '')
end

local function formatDayValue(duration, day_pages, total_percent)
    local perc = string.format("%.2f", total_percent * 100)
    local mpp = datetime.secondsToClockDuration("classic", duration / day_pages)
    if #mpp == 8 then
        mpp = mpp:gsub("^00?:", "") -- hh:mm:ss -> mm:ss
    end
    return string.format(
        "%s  %s  Ø %s  → %s%%",
        datetime.secondsToClockDuration("classic", duration, true):gsub("^0(%d:)", "%1"), -- h:mm
        padLeft(tostring(day_pages), 3, "(", ")"),
        mpp:gsub("^0(%d:)", "%1"),
        padLeft(perc, 5)
    )
end

userpatch.registerPatchPluginFunc("statistics", function(ReaderStatistics)
    function ReaderStatistics:getDatesForBook(id_book)
        local results = {}

        local db_location = DataStorage:getSettingsDir() .. "/statistics.sqlite3"
        local conn = SQ3.open(db_location)
        local sql_stmt = [[
            SELECT date(ps.start_time, 'unixepoch', 'localtime') AS dates,
                   count(DISTINCT ps.page)                       AS pages,
                   sum(ps.duration)                              AS durations,
                   min(ps.start_time)                            AS min_start_time,
                   max(ps.start_time)                            AS max_start_time,
                   (SELECT (page * 1.0 / total_pages)
                    FROM page_stat_data ps2
                    WHERE ps2.id_book = ps.id_book
                      AND date(ps2.start_time, 'unixepoch', 'localtime') = date(ps.start_time, 'unixepoch', 'localtime')
                    ORDER BY ps2.start_time DESC
                    LIMIT 1)                                     AS total_percentage
            FROM   page_stat_data ps
            WHERE  ps.id_book = %d
            GROUP  BY date(ps.start_time, 'unixepoch', 'localtime')
            ORDER  BY dates DESC;
        ]]

        local result_book = conn:exec(string.format(sql_stmt, id_book))
        conn:close()

        if result_book == nil then
            return {}
        end

        for i = 1, #result_book.dates do
            local day_pages = tonumber(result_book[2][i]) or 0
            local duration = tonumber(result_book[3][i]) or 0
            local total_percentage = tonumber(result_book[6][i]) or 0
            table.insert(results, {
                result_book[1][i],
                formatDayValue(duration, day_pages, total_percentage),
                hold_callback = function(kv_page, kv_item)
                    self:resetStatsForBookForPeriod(id_book, result_book[4][i], result_book[5][i], result_book[1][i], function()
                        kv_page:removeKeyValueItem(kv_item)
                    end)
                end,
            })
        end

        return results
    end
end)
