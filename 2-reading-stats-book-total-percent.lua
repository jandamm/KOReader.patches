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

local function formatDayValue(user_duration_format, duration, day_pages, total_percent)
    local value = T(
        N_("%1 (1 page)", "%1 (%2 pages)", day_pages),
        datetime.secondsToClockDuration(user_duration_format, duration, false),
        day_pages
    )

    if total_percent and total_percent > 0 then
        value = string.format("%s → %.2f%%", value, total_percent * 100)
    end

    return value
end

userpatch.registerPatchPluginFunc("statistics", function(ReaderStatistics)
    function ReaderStatistics:getDatesForBook(id_book)
        local results = {}

        local db_location = DataStorage:getSettingsDir() .. "/statistics.sqlite3"
        local conn = SQ3.open(db_location)
        local sql_stmt = [[
            SELECT date(start_time, 'unixepoch', 'localtime') AS dates,
                   count(DISTINCT page)                       AS pages,
                   sum(duration)                              AS durations,
                   min(start_time)                            AS min_start_time,
                   max(start_time)                            AS max_start_time,
                   max((page * 1.0) / total_pages)            AS total_percentage
            FROM   page_stat_data
            WHERE  id_book = %d
            GROUP  BY Date(start_time, 'unixepoch', 'localtime')
            ORDER  BY dates DESC;
        ]]

        local result_book = conn:exec(string.format(sql_stmt, id_book))
        conn:close()

        if result_book == nil then
            return {}
        end

        local user_duration_format = G_reader_settings:readSetting("duration_format")
        for i = 1, #result_book.dates do
            local day_pages = tonumber(result_book[2][i]) or 0
            local duration = tonumber(result_book[3][i]) or 0
            local total_percentage = tonumber(result_book[6][i]) or 0
            table.insert(results, {
                result_book[1][i],
                formatDayValue(user_duration_format, duration, day_pages, total_percentage),
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
