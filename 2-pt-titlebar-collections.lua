--[[
This user patch is primarily for use with the Project: Title plugin. It requires
Project: Title v3.5 or higher.

It replaces a button in the top toolbar.

You can choose a new icon and new actions for tap and long-press. If you set
icon, tap, or hold to nil then the original value is kept. In this way you
could keep an button's icon and tap action and add only a long-press action
to it.

Icons are set by using their filename without extension, eg: "check" will use
the image file /koreader/resources/icons/mdlite/check.svg

Icons can be any of the ones bundled with KOReader in /koreader/resources/icons
or you can add your own to /koreader/icons

You can manually program a button to do absolutely anything, but the fastest
method is to use the functions defined by, and added to, Dispatcher.

You can find all predefined functions at the link below. For functions added
by plugins, you'll have to go digging into their code to find them.

https://github.com/koreader/koreader/blob/master/frontend/dispatcher.lua
--]]

-- Adjusted by me to show favorites on tap and last book on hold
-- Source: https://github.com/joshuacant/KOReader.patches/blob/main/2-toolbar-replace-button.lua

local userpatch = require("userpatch")
local Dispatcher = require("dispatcher")

local button_to_replace = "right3"

-- don't change anything below this line
local function patchCoverBrowser(plugin)
    local TitleBar = require("titlebar")
    local orig_TitleBar_init = TitleBar.init
    TitleBar.init = function(self)
        self[button_to_replace .. "_icon"] = "star.empty"
        self[button_to_replace .. "_icon_tap_callback"] = function() Dispatcher:execute({ "collections" }) end
        self[button_to_replace .. "_icon_hold_callback"] = function() Dispatcher:execute({ "open_previous_document" }) end
        orig_TitleBar_init(self)
    end
end
userpatch.registerPatchPluginFunc("coverbrowser", patchCoverBrowser)
