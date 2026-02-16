local DocSettings = require("docsettings")
local DocumentRegistry = require("document/documentregistry")
local ReadHistory = require("readhistory")
local util = require("util")

local user_path = "/mnt/onboard/.koreader/"

-- https://github.com/koreader/koreader/issues/10308#issuecomment-1507743114
-- And following comments

local function isInHome(path)
    return util.stringStartsWith(path, user_path)
end
local function isInBooks(path)
    return util.stringStartsWith(path, user_path .. "Books/")
end

-- Ignore files for Reading Stats
local orig_openDocument = DocumentRegistry.openDocument
DocumentRegistry.openDocument = function(self, file, provider)
    local doc = orig_openDocument(self, file, provider)
    if doc and not isInBooks(file) then
        doc.is_pic = true
    end
    return doc
end

-- Prevent creating settings for files
local orig_flush = DocSettings.flush
function DocSettings:flush(data)
    if self and self.data and self.data.doc_path and not isInHome(self.data.doc_path) then
        return
    end
    orig_flush(self, data)
end

-- Ignore files for Book History
local orig_addItem = ReadHistory.addItem
function ReadHistory:addItem(file, ts, no_flush)
    if file ~= nil and not isInBooks(file) then
        return
    end
    orig_addItem(self, file, ts, no_flush)
end
