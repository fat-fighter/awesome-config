-- =====================================================================================
--   Name:       keys.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/config-awesome/keys.lua
--   License:    The MIT License (MIT)
--
--   Custom keybindings for awesomewm
-- =====================================================================================

local join = require("gears").table.join
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local switcher = require("modules.switcher")

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local keys = require("components.keys")
local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Running daemons

require("daemons.mpris")
require("daemons.volume")
require("daemons.brightness")

-- -------------------------------------------------------------------------------------
-- Setting Mod Keys

superkey = "Mod4" -- Windows key

altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"

-- -------------------------------------------------------------------------------------
-- Defining Local Variables and Functions

keys = {
    clientkeys = keys.clientkeys or {},
    globalkeys = keys.globalkeys or {},
    clientbuttons = keys.clientbuttons or {},
    desktopbuttons = keys.desktopbuttons or {}
}

local docked = false

-- -------------------------------------------------------------------------------------
-- Global Shortcuts

-- Desktop Buttons {{{
keys.desktopbuttons =
    join(
    awful.button(
        {},
        1,
        function()
            naughty.destroy_all_notifications()
        end
    ),
    keys.desktopbuttons
)
-- }}}

-- Function keys {{{
keys.globalkeys =
    join(
    awful.key(
        {superkey, shiftkey},
        "r",
        awesome.restart,
        {description = "reload awesome", group = "awesome"}
    ),
    awful.key(
        {ctrlkey},
        "space",
        function()
            naughty.destroy_all_notifications()
        end,
        {description = "dismiss notification", group = "notifications"}
    ),
    -- Screenshots {
    awful.key(
        {},
        "Print",
        function()
            awful.spawn.with_shell("kazam -a --nosound")
        end,
        {description = "select area to capture screenshot", group = "screenshots"}
    ),
    awful.key(
        {superkey},
        "Print",
        function()
            awful.spawn.with_shell("kazam -w --nosound")
        end,
        {description = "capture whole screen", group = "screenshots"}
    ),
    awful.key(
        {superkey, shiftkey},
        "Print",
        function()
            awful.spawn.with_shell(scripts_dir .. "pin-scrot")
        end,
        {description = "capture whole screen", group = "screenshots"}
    ),
    -- }

    -- Media {
    awful.key(
        {superkey},
        "period",
        function()
            awesome.emit_signal("controls::mpris", "next")
        end,
        {description = "next", group = "media"}
    ),
    awful.key(
        {superkey},
        "comma",
        function()
            awesome.emit_signal("controls::mpris", "prev")
        end,
        {description = "prev", group = "media"}
    ),
    awful.key(
        {superkey},
        "space",
        function()
            awesome.emit_signal("controls::mpris", "toggle")
        end,
        {description = "toggle", group = "media"}
    ),
    -- }

    -- Brightness {
    awful.key(
        {},
        "XF86MonBrightnessUp",
        function()
            awesome.emit_signal("controls::brightness", "increase")
        end,
        {description = "increase brightness", group = "brightness"}
    ),
    awful.key(
        {},
        "XF86MonBrightnessDown",
        function()
            awesome.emit_signal("controls::brightness", "decrease")
        end,
        {description = "decrease brighness", group = "brightness"}
    ),
    -- }

    -- Audio {
    awful.key(
        {},
        "XF86AudioMute",
        function()
            awesome.emit_signal("controls::volume", "mute")
        end,
        {description = "(un)mute volume", group = "volume"}
    ),
    awful.key(
        {},
        "XF86AudioRaiseVolume",
        function()
            awesome.emit_signal("controls::volume", "increase")
        end,
        {description = "raise volume", group = "volume"}
    ),
    awful.key(
        {},
        "XF86AudioLowerVolume",
        function()
            awesome.emit_signal("controls::volume", "decrease")
        end,
        {description = "lower volume", group = "volume"}
    ),
    awful.key(
        {},
        "XF86AudioPlay",
        function()
            awesome.emit_signal("controls::mpris", "toggle")
        end,
        {description = "toggle", group = "media"}
    ),
    awful.key(
        {},
        "XF86AudioPrev",
        function()
            awesome.emit_signal("controls::mpris", "prev")
        end,
        {description = "prev", group = "media"}
    ),
    awful.key(
        {},
        "XF86AudioNext",
        function()
            awesome.emit_signal("controls::mpris", "next")
        end,
        {description = "next", group = "media"}
    ),
    -- }

    keys.globalkeys
)
-- }}}

-- Program shortcuts {{{
keys.globalkeys =
    join(
    -- Terminal {
    awful.key(
        {superkey},
        "t",
        function()
            awful.spawn(terminal)
        end,
        {description = "spawn terminal", group = "launcher"}
    ),
    awful.key(
        {superkey, shiftkey},
        "t",
        function()
            awful.spawn(
                terminal,
                {
                    floating = true,
                    width = helpers.screen_width() * 0.45,
                    height = helpers.screen_height() * 0.5,
                    titlebars_enabled = false,
                    placement = awful.placement.centered
                }
            )
        end,
        {description = "spawn floating terminal", group = "launcher"}
    ),
    -- }

    awful.key(
        {superkey},
        "Return",
        function()
            awful.spawn.with_shell(
                os.getenv("HOME") .. "/.config/rofi/launcher.sh " .. theme_name
            )
        end,
        {description = "spawn rofi app launcer", group = "launcher"}
    ),
    awful.key(
        {superkey},
        "l",
        function()
            awful.spawn.with_shell(
                os.getenv("HOME") .. "/.config/rofi/powermenu.sh " .. theme_name
            )
        end,
        {description = "spawn rofi powermenu", group = "launcher"}
    ),
    awful.key(
        {superkey},
        "o",
        function()
            awful.spawn(filemanager)
        end,
        {description = "spawn ranger", group = "launcher"}
    ),
    awful.key(
        {superkey},
        "e",
        function()
            awful.spawn(editor)
        end,
        {description = "spawn editor", group = "launcher"}
    ),
    awful.key(
        {superkey, shiftkey},
        "e",
        function()
            awful.spawn(
                editor,
                {
                    floating = true,
                    width = helpers.screen_width() * 0.45,
                    height = helpers.screen_height() * 0.5,
                    titlebars_enabled = false,
                    placement = awful.placement.centered
                }
            )
        end,
        {description = "spawn small floating editor", group = "launcher"}
    ),
    awful.key(
        {superkey},
        "Escape",
        function()
            require("awful.hotkeys_popup").show_help()
        end,
        {description = "show help", group = "awesome"}
    ),
    keys.globalkeys
)
-- }}}

-- -------------------------------------------------------------------------------------
-- Client Window Management Keys

-- Focus {{{

-- Direction {
do
    local directions = {"Up", "Right", "Down", "Left"}

    for _, direction in ipairs(directions) do
        keys.globalkeys =
            join(
            awful.key(
                {superkey},
                direction,
                function()
                    awful.client.focus.bydirection(direction:lower())
                    if client.focus then
                        client.focus:raise()
                    end
                end,
                {description = "focus " .. direction:lower(), group = "client"}
            ),
            keys.globalkeys
        )
    end
end
-- }

keys.globalkeys =
    join(
    -- Index {
    awful.key(
        {superkey},
        "j",
        function()
            awful.client.focus.byidx(1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key(
        {superkey},
        "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- }

    awful.key(
        {superkey},
        "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus previously active", group = "client"}
    ),
    awful.key(
        {altkey},
        "Tab",
        function()
            switcher.switch(1, "Mod1", "Alt_L", "Shift", "Tab")
        end,
        {description = "show switcher and focus next active", group = "client"}
    ),
    awful.key(
        {altkey, shiftkey},
        "Tab",
        function()
            switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab")
        end,
        {description = "show switcher and focus previous active", group = "client"}
    ),
    awful.key(
        {superkey},
        "u",
        function()
            uc = awful.client.urgent.get()
            if uc ~= nil then
                awful.client.urgent.jumpto()
            end
        end,
        {description = "focus urgent client", group = "client"}
    ),
    keys.globalkeys
)
-- }}}

-- Layout {{{
do
    local directions = {"Up", "Right", "Down", "Left"}

    for _, direction in ipairs(directions) do
        -- Moving clients {
        keys.clientkeys =
            join(
            awful.key(
                {superkey, shiftkey},
                direction,
                function(c)
                    local current_layout =
                        awful.layout.getname(awful.layout.get(helpers.get_screen()))

                    if current_layout == "floating" or c.floating then
                        helpers.move_client_to_edge(c, direction:lower())
                    else
                        awful.client.swap.bydirection(direction:lower(), c, nil)
                    end
                end,
                {description = "move " .. direction:lower(), group = "client"}
            ),
            -- }

            -- Shifting floating clients {
            awful.key(
                {superkey, ctrlkey, shiftkey},
                direction,
                function(c)
                    local current_layout =
                        awful.layout.getname(awful.layout.get(helpers.get_screen()))

                    if current_layout == "floating" or c.floating then
                        helpers.shift_client(c, direction:lower())
                    end
                end,
                {description = "shift " .. direction:lower(), group = "client"}
            ),
            keys.clientkeys
        )
        -- }
    end
end

keys.clientkeys =
    join(
    awful.key(
        {superkey, shiftkey},
        "c",
        function(c)
            awful.placement.centered(c, {honor_workarea = true})
        end,
        {description = "move to center", group = "client"}
    ),
    keys.clientkeys
)

-- }}}

-- Minimize and maximize {{{
keys.globalkeys =
    join(
    awful.key(
        {superkey, shiftkey},
        "n",
        function()
            local c = awful.client.restore()
            if c then
                client.focus = c
                c:raise()
            end
        end,
        {description = "restore minimized", group = "client"}
    ),
    keys.globalkeys
)

keys.clientkeys =
    join(
    awful.key(
        {superkey},
        "n",
        function(c)
            c.minimized = true
        end,
        {description = "minimize", group = "client"}
    ),
    awful.key(
        {superkey},
        "m",
        function(c)
            c.maximized = not c.maximized
        end,
        {description = "(un)maximize", group = "client"}
    ),
    awful.key(
        {superkey, shiftkey},
        "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
        end,
        {description = "(un)maximize vertically", group = "client"}
    ),
    awful.key(
        {superkey, ctrlkey},
        "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
        end,
        {description = "(un)maximize horizontally", group = "client"}
    ),
    awful.key(
        {superkey},
        "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}
    ),
    keys.clientkeys
)
-- }}}

-- Titlebars {{{
keys.clientkeys =
    join(
    awful.key(
        {superkey},
        "v",
        function(c)
            if not beautiful.titlebars_imitate_borders then
                awful.titlebar.toggle(c, beautiful.titlebar_position)
            end
        end,
        {description = "toggle titlebar", group = "client"}
    ),
    keys.clientkeys
)

keys.globalkeys =
    join(
    awful.key(
        {superkey, shiftkey},
        "v",
        function()
            local clients = helpers.get_screen().clients
            for _, c in pairs(clients) do
                if not beautiful.titlebars_imitate_borders then
                    awful.titlebar.toggle(c, beautiful.titlebar_position)
                end
            end
        end,
        {description = "toggle titlebar for all clients in tag", group = "client"}
    ),
    keys.globalkeys
)
-- }}}

-- Floating {{{
keys.clientkeys =
    join(
    awful.key(
        {superkey, ctrlkey},
        "space",
        function(c)
            local current_layout =
                awful.layout.getname(awful.layout.get(helpers.get_screen()))
            if not c.fullscreen and current_layout ~= "floating" then
                c.floating = not c.floating
            end
        end,
        {description = "toggle floating", group = "client"}
    ),
    awful.key(
        {superkey, ctrlkey},
        "f",
        function(c)
            -- Set floating with medium sized float
            if c.fullscreen then
                return
            end

            c.floating = true

            c.width = helpers.screen_width() * 0.7
            c.height = helpers.screen_height() * 0.75

            awful.placement.centered(c, {honor_workarea = true})
        end,
        {description = "focus floating mode", group = "client"}
    ),
    awful.key(
        {superkey, ctrlkey},
        "t",
        function(c)
            -- Set floating with tiny sized float
            if c.fullscreen then
                return
            end

            c.floating = true

            c.width = helpers.screen_width() * 0.3
            c.height = helpers.screen_height() * 0.35

            awful.placement.centered(c, {honor_workarea = true})
        end,
        {description = "tiny floating mode", group = "client"}
    ),
    awful.key(
        {superkey, ctrlkey},
        "v",
        function(c)
            -- Set floating with medium sized float
            if c.fullscreen then
                return
            end

            c.floating = true

            c.width = helpers.screen_width() * 0.45
            c.height = helpers.screen_height() * 0.5

            awful.placement.centered(c, {honor_workarea = true})
        end,
        {description = "normal floating mode", group = "client"}
    ),
    keys.clientkeys
)
-- }}}

-- Client properties {{{
keys.clientkeys =
    join(
    awful.key(
        {superkey, shiftkey},
        "o",
        function(c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}
    ),
    awful.key(
        {superkey, shiftkey},
        "s",
        function(c)
            c.sticky = not c.sticky
        end,
        {description = "toggle sticky", group = "client"}
    ),
    keys.clientkeys
)
-- }}}

-- Mouse events {{{
keys.clientbuttons =
    join(
    awful.button(
        {},
        1,
        function(c)
            client.focus = c
            c:raise()
        end,
        {description = "focus", group = "client"}
    ),
    awful.button(
        {superkey},
        1,
        awful.mouse.client.move,
        {description = "move", group = "client"}
    ),
    keys.clientbuttons
)
-- }}}

-- Quit {{{
keys.clientkeys =
    join(
    awful.key(
        {superkey},
        "q",
        function(c)
            c:kill()
        end,
        {description = "close", group = "client"}
    ),
    keys.clientkeys
)
-- }}}

-- -------------------------------------------------------------------------------------
-- Layout Management Keys

-- Layout {{{
keys.globalkeys =
    join(
    -- Cycle through layous {
    awful.key(
        {superkey, altkey},
        "space",
        function()
            awful.layout.inc(1)
        end,
        {description = "select next layout", group = "layout"}
    ),
    awful.key(
        {superkey, altkey, shiftkey},
        "space",
        function()
            awful.layout.inc(-1)
        end,
        {description = "select previous layout", group = "layout"}
    ),
    -- }

    -- Set fixed layout {
    awful.key(
        {superkey},
        "w",
        function()
            awful.layout.set(awful.layout.suit.max)
        end,
        {description = "set max layout", group = "layout"}
    ),
    awful.key(
        {superkey},
        "d",
        function()
            awful.layout.set(awful.layout.suit.spiral.dwindle)
        end,
        {description = "set spiral dwindle layout", group = "layout"}
    ),
    awful.key(
        {superkey},
        "a",
        function()
            awful.layout.set(awful.layout.suit.fair)
        end,
        {description = "set fair layout", group = "layout"}
    ),
    awful.key(
        {superkey},
        "s",
        function()
            awful.layout.set(awful.layout.suit.floating)
        end,
        {description = "set floating layout", group = "layout"}
    ),
    -- }

    keys.globalkeys
)
-- }}}

-- Layout clients configuration {{{
keys.globalkeys =
    join(
    -- Master width factor | Floating clients width {
    awful.key(
        {superkey, ctrlkey},
        "minus",
        function()
            local current_layout =
                awful.layout.getname(awful.layout.get(helpers.get_screen()))
            local c = client.focus

            -- If floating, decrease width
            if current_layout == "floating" or (c ~= nil and c.floating == true) then
                c:relative_move(10, 0, -20, 0)
            else
                awful.tag.incmwfact(-0.05)
            end
        end,
        {
            description = "decrease master width factor or width for floating client",
            group = "layout"
        }
    ),
    awful.key(
        {superkey, ctrlkey},
        "equal",
        function()
            local current_layout =
                awful.layout.getname(awful.layout.get(helpers.get_screen()))
            local c = client.focus

            -- If floating, increase width
            if current_layout == "floating" or (c ~= nil and c.floating == true) then
                c:relative_move(-10, 0, 20, 0)
            else
                awful.tag.incmwfact(0.05)
            end
        end,
        {
            description = "increase master width factor or width for floating client",
            group = "layout"
        }
    ),
    -- }

    -- Number of master clients | Floating clients height {
    awful.key(
        {superkey, shiftkey},
        "minus",
        function()
            local current_layout =
                awful.layout.getname(awful.layout.get(helpers.get_screen()))
            local c = client.focus

            if current_layout == "floating" or (c ~= nil and c.floating == true) then
                c:relative_move(0, 10, 0, -20)
            else
                awful.tag.incnmaster(-1, nil, true)
            end
        end,
        {
            description = ("decrease number of master clients or height for floating client"),
            group = "layout"
        }
    ),
    awful.key(
        {superkey, shiftkey},
        "equal",
        function()
            local current_layout =
                awful.layout.getname(awful.layout.get(helpers.get_screen()))
            local c = client.focus

            if current_layout == "floating" or (c ~= nil and c.floating == true) then
                c:relative_move(0, -10, 0, 20)
            else
                awful.tag.incnmaster(1, nil, true)
            end
        end,
        {
            description = ("increase number of master clients or height for floating client"),
            group = "layout"
        }
    ),
    -- }

    -- Number of non-master columns {
    awful.key(
        {superkey, ctrlkey, shiftkey},
        "equal",
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {description = "increase the number of non-master columns", group = "layout"}
    ),
    awful.key(
        {superkey, ctrlkey, shiftkey},
        "minus",
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "increase the number of non-master columns", group = "layout"}
    ),
    -- }

    keys.globalkeys
)
-- }}}

-- -------------------------------------------------------------------------------------
-- Tag Control Keys

-- Moving {{{
keys.globalkeys =
    join(
    awful.key(
        {superkey, ctrlkey},
        "Left",
        awful.tag.viewprev,
        {description = "view previous", group = "tag"}
    ),
    awful.key(
        {superkey, ctrlkey},
        "Right",
        awful.tag.viewnext,
        {description = "view next", group = "tag"}
    ),
    keys.globalkeys
)
-- }}}

-- Clients {{{
for i = 1, ntags do
    keys.globalkeys =
        join(
        -- View tag
        awful.key(
            {superkey},
            "#" .. i + 9,
            function()
                local screen = helpers.get_screen()
                local tag = screen.tags[i]
                local current_tag = screen.selected_tag

                if tag then
                    if tag == current_tag then
                        awful.tag.history.restore()
                    else
                        tag:view_only()
                    end
                end
            end,
            {description = "view tag #" .. i, group = "tag"}
        ),
        -- Toggle tag display
        awful.key(
            {superkey, ctrlkey},
            "#" .. i + 9,
            function()
                local screen = helpers.get_screen()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),
        -- Move client to tag
        awful.key(
            {superkey, shiftkey},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}
        ),
        -- Toggle client on tag
        awful.key(
            {superkey, ctrlkey, shiftkey},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        ),
        keys.globalkeys
    )
end

for i = 1, 2 do
    keys.globalkeys =
        join(
        -- View tag
        awful.key(
            {superkey, altkey},
            "#" .. i + 9,
            function()
                local screen = helpers.get_screen()
                local tag = screen.tags[4 + i]
                local current_tag = screen.selected_tag

                if tag then
                    if tag == current_tag then
                        awful.tag.history.restore()
                    else
                        tag:view_only()
                    end
                end
            end,
            {description = "view tag #" .. i, group = "tag"}
        ),
        -- Toggle tag display
        awful.key(
            {superkey, ctrlkey, altkey},
            "#" .. i + 9,
            function()
                local screen = helpers.get_screen()
                local tag = screen.tags[4 + i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}
        ),
        -- Move client to tag
        awful.key(
            {superkey, shiftkey, altkey},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[4 + i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #" .. i, group = "tag"}
        ),
        -- Toggle client on tag
        awful.key(
            {superkey, ctrlkey, shiftkey, altkey},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[4 + i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"}
        ),
        keys.globalkeys
    )
end
-- }}}

-- -------------------------------------------------------------------------------------
-- Screen Control Keys

-- Screen controls {{{
keys.globalkeys =
    join(
    awful.key(
        {superkey, altkey},
        "m",
        function()
            if docked then
                awful.spawn(
                    "xrandr --output eDP1 --auto --output HDMI-1-0 --off"
                )
            else
                awful.spawn(
                    "xrandr --output HDMI-1-0 --auto --output eDP1 --off"
                )
            end
            docked = not docked
        end,
        {description = "dock/undock laptop", group = "screen"}
    ),
    keys.globalkeys
)
-- }}}

-- Moving {{{
do
    local directions = {"Up", "Right", "Down", "Left"}

    for _, direction in ipairs(directions) do
        keys.globalkeys =
            join(
            awful.key(
                {superkey, altkey},
                direction,
                function()
                    local c = client.focus
                    client.focus = nil

                    local s = helpers.get_screen()
                    awful.screen.focus_bydirection(direction:lower())

                    if s == helpers.get_screen() then
                        client.focus = c
                    end
                end,
                {description = "view screen on " .. direction:lower(), group = "screen"}
            ),
            keys.globalkeys
        )
    end
end
-- }}}

-- Clients {{{
do
    local directions = {"Up", "Right", "Down", "Left"}

    for _, direction in ipairs(directions) do
        keys.globalkeys =
            join(
            awful.key(
                {superkey, altkey, shiftkey},
                direction,
                function()
                    if client.focus then
                        local c = client.focus
                        local screen =
                            helpers.get_screen():get_next_in_direction(
                            direction:lower()
                        )

                        c:move_to_screen(screen)
                        c:raise()
                    end
                end,
                {
                    description = "move client to screen on " .. direction:lower(),
                    group = "screen"
                }
            ),
            keys.globalkeys
        )
    end
end
-- }}}

-- -------------------------------------------------------------------------------------
-- Set Keys and Buttons

root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

-- -------------------------------------------------------------------------------------
return keys
