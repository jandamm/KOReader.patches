-- Source: https://github.com/medinauta/Koreader-Patches/blob/main/2-confirm-first-open.lua

-- Confirm before opening a book for the first time

local FileManager = require("apps/filemanager/filemanager")
local ConfirmBox = require("ui/widget/confirmbox")
local UIManager = require("ui/uimanager")
local DocSettings = require("docsettings")
local logger = require("logger")
local util = require("util")

if not FileManager._confirm_first_open_patched then
    FileManager._confirm_first_open_patched = true
    logger.dbg("[ConfirmFirstOpen] Patching FileManager.openFile")

    local function isInHome(path)
        local home = G_reader_settings:readSetting("home_dir"):match("(.*)/?") .. "/"
        return util.stringStartsWith(path, home)
    end

    local orig_openFile = FileManager.openFile

    FileManager.openFile = function(self, path, ...)
        local args = { ... }

        if not isInHome(path) then
            return orig_openFile(self, path, unpack(args))
        end

        local ok, has_sidecar = pcall(function()
            return DocSettings:hasSidecarFile(path)
        end)

        if ok and has_sidecar then
            return orig_openFile(self, path, unpack(args))
        end

        local dialog
        dialog = ConfirmBox:new{
            title = "First Time Opening This Book",
            text =
            "This book has never been opened on this device.\n\n"
            .. "Do you want to open this book now?",
            ok_text = "Open Book",
            cancel_text = "Cancel",
            ok_callback = function()
                UIManager:close(dialog)
                orig_openFile(self, path, unpack(args))
            end,
            cancel_callback = function()
                UIManager:close(dialog)
            end,
        }

        UIManager:show(dialog)
        return true
    end
end
