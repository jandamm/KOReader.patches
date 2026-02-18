-- Needs Project Title v3.7+

--[[ 
This patch lets you increase the size of all (created while this patch is active) cover images.

Please be sure that this patch will:
  - Might make ProjectTitle slow on older devices when there are a lot of covers visible on a page.
    Depending on your settings even on faster devices. I tested 2000 and it was unusable on my eReader.
  - Increase the size of the cache

--]]

local max_cover_dimension = 750 -- default 600

local userpatch = require("userpatch")

local function patchCoverBrowser(plugin)
    local BIM = require("bookinfomanager")
    BIM.max_cover_dimen = max_cover_dimension
end

userpatch.registerPatchPluginFunc("coverbrowser", patchCoverBrowser)

