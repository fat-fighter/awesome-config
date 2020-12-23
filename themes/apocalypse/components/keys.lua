-- =====================================================================================
--   Name:       keys.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/ ...
--               ... components/keys.lua
--   License:    The MIT License (MIT)
--
--   Theme specific custom keybindings
-- =====================================================================================

local join = require("gears").table.join
local awful = require("awful")
local gears = require("gears")

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

keys.globalkeys =
    join(
    awful.key(
        {superkey},
        "grave",
        function()
            awful.screen.focused().controlpanel:toggle()
        end,
        {description = "toggle controlpanel", group = "awesome"}
    ),
    awful.key(
        {superkey, altkey},
        "grave",
        function()
            awful.spawn(
                "kitty -e googlesamples-assistant-pushtotalk --project-id future-silicon-285600 " ..
                    "--device-model-id future-silicon-285600-laptop"
            )
        end,
        {description = "toggle tray visibility", group = "awesome"}
    ),
    awful.key(
        {superkey},
        "equal",
        function()
            local screen = awful.screen.focused()
            screen.systray:toggle(screen)
        end,
        {description = "toggle tray visibility", group = "awesome"}
    ),
    keys.globalkeys
)

-- -------------------------------------------------------------------------------------
-- Adding Bar Keys

keys.taglist_buttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(tag)
            local screen = awful.screen.focused({client = true, mouse = true})
            local current_tag = screen.selected_tag

            if tag then
                if tag == current_tag then
                    awful.tag.history.restore()
                else
                    tag:view_only()
                end
            end
        end
    ),
    awful.button(
        {superkey},
        1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button(
        {},
        3,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end
    ),
    awful.button(
        {superkey},
        3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end
    ),
    awful.button(
        {},
        4,
        function(t)
            awful.tag.viewprev(t.screen)
        end
    ),
    awful.button(
        {},
        5,
        function(t)
            awful.tag.viewnext(t.screen)
        end
    )
)

-- -------------------------------------------------------------------------------------
return keys
