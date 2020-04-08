-- =====================================================================================
--   Name:       keys.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/thunderclouds/ ...
--               ... components/keys.lua
--   License:    The MIT License (MIT)
--
--   Theme specific custom keybindings
-- =====================================================================================

local join = require("gears").table.join
local awful = require("awful")

-- -------------------------------------------------------------------------------------
-- Setting Mod Keys

superkey = "Mod4" -- Windows key

altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"

-- -------------------------------------------------------------------------------------
-- Defining Local Variables

local keys = {
    clientkeys = {},
    globalkeys = {},
    clientbuttons = {},
    desktopbuttons = {}
}

-- -------------------------------------------------------------------------------------
-- Adding Global Keys

keys.globalkeys = join(
    awful.key(
        {superkey}, "grave",
        function()
            awful.screen.focused().startscreen:toggle()
        end,
        {description = "toggle startscreen", group = "awesome"}
    ),

    awful.key(
        {superkey}, "equal",
        function()
            awful.screen.focused().systray:toggle()
        end,
        {description = "toggle tray visibility", group = "awesome"}
    ),

    keys.globalkeys
)

-- -------------------------------------------------------------------------------------
return keys
