local DataStorage = require("datastorage")
local DocSettings = require("docsettings")
local DocumentRegistry = require("document/documentregistry")
local ReadHistory = require("readhistory")
local util = require("util")

-- https://github.com/koreader/koreader/issues/10308#issuecomment-1507743114
-- And following comments

local function isInDataDir(path)
    return util.stringStartsWith(path, DataStorage:getDataDir())
end
local function isInHome(path)
    local home = G_reader_settings:readSetting("home_dir"):match("(.*)/?") .. "/"
    return util.stringStartsWith(path, home)
end

-- Ignore files for Reading Stats
local orig_openDocument = DocumentRegistry.openDocument
function DocumentRegistry:openDocument(file, ...)
    local doc = orig_openDocument(self, file, ...)
    if doc and not isInHome(file) then
        doc.is_pic = true
    end
    return doc
end

-- Prevent creating settings for files in data dir (koreader folder)
local orig_flush = DocSettings.flush
function DocSettings:flush(data, ...)
    if self and self.data and self.data.doc_path and isInDataDir(self.data.doc_path) then
        return
    end
    return orig_flush(self, data, ...)
end

-- Ignore files for Book History
local orig_addItem = ReadHistory.addItem
function ReadHistory:addItem(file, ...)
    if file ~= nil and not isInHome(file) then
        return
    end
    return orig_addItem(self, file, ...)
end
