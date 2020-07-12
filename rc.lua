--                                                  `'::.
--    ██████             ██                    _________H ,%%&%,
--   ░███░░██           ░██                    /\   _   \%&&%%&%
--   ░███ ░░   █████    █████                 /  \___/^\___\%&%%&&
--   █████    ░░░░░██  ░░███                  |  | []   [] |%\Y&%'
--  ░░███      ██████   ░██                   |  |   .-.   | ||
--   ░██      ███░░██   ░███                ~~|  |   |||   |~||~~~~~~
--   ████     ░███████  ░░███                ~^~^~^~^~^~^~^~^~^~^~^~
--  ░░░░      ░░░░░░░    ░░░
--         █████    ████    ██    ███   █████    ████   █████   █████████████    █████
--        ░░░░░██  ░░███   ████   ██   ███░░██ ░███░   ███░░██ ░░███░░███░░██   ███░░██
--         ██████   ░░███ ██████ ██   ░██████   ░███  ░███ ░██  ░███ ░███ ░██  ░██████
--        ███░░██    ░░█████░░████    ░███░░    ░░░██ ░███ ░██  ░███ ░███ ░██  ░███░░
--        ░███████    ░░███  ░░██     ░░██████  ████  ░░█████   █████░███ ████ ░░██████
--        ░░░░░░░      ░░░    ░░       ░░░░░░  ░░░░    ░░░░░   ░░░░░ ░░░ ░░░░   ░░░░░░
--
-- =====================================================================================
--   Name:       fat ⌂ awesome
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/config-awesome/rc.lua
--   License:    The MIT License (MIT)
--
--   Configuration file for awesomewm
-- =====================================================================================

-- Choosing awful theme
local theme_collection = {
    "apocalypse",
    "thunderclouds"
}

-- Change this number to use a different theme
theme_name = os.getenv("THEME") or theme_collection[1]
theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/"

-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

require("awful.autofocus")

local gears = require("gears")
local awful = require("awful")

local lgi = require("lgi")
local Gio = lgi.require("Gio")

-- -------------------------------------------------------------------------------------
-- Defining Global Variables

terminal = "kitty"
editor = terminal .. " -e vim"
filemanager = terminal .. " -e ranger"

ntags = 6

config_dir = os.getenv("HOME") .. "/.config/awesome/"
scripts_dir = config_dir .. "scripts/"

system_bus = Gio.bus_get_sync(Gio.BusType.SYSTEM)
session_bus = Gio.bus_get_sync(Gio.BusType.SESSION)

-- -------------------------------------------------------------------------------------
-- Initializing the Theme

local beautiful = require("beautiful")

if not beautiful.init(theme_dir .. "theme.lua") then
    local naughty = require("naughty")
    naughty.notify(
        {
            text = "Error loading theme " .. theme_name .. " from " .. theme_dir,
            preset = naughty.config.presets.critical
        }
    )
end

-- -------------------------------------------------------------------------------------
-- Running Cleanup Script

os.execute(scripts_dir .. "cleanup.sh")

-- -------------------------------------------------------------------------------------
-- Setting Tags

beautiful.ntags = ntags

local tagnames = {
    "browser",
    "editor",
    "reading",
    "terminal",
    "code",
    "chill",
    "music",
    "social"
}

beautiful.tagnames = tagnames

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

package.path = package.path .. ";" .. theme_dir .. "?.lua"

local keys = require("keys")
local naughty = require("components.notify")
local handlers = require("handlers")
require("awful.remote")
require("screenful")

require("components.titlebar")

-- -------------------------------------------------------------------------------------
-- Error Handling

-- Throw startup errors {{{
if awesome.startup_errors then
    naughty.notify {
        text = awesome.startup_errors,
        title = "Oops, there were errors during startup!",
        preset = naughty.config.presets.critical
    }
end
-- }}}

-- Handle runtime errors after startup {{{
local in_error = false
awesome.connect_signal(
    "debug::error",
    function(err)
        if in_error then
            return
        end
        in_error = true

        naughty.notify {
            text = tostring(err),
            title = "Oops, an error happened!",
            preset = naughty.config.presets.critical
        }
        in_error = false
    end
)
-- }}}

-- -------------------------------------------------------------------------------------
-- Choosing Layouts

-- Choosing possible layouts for a tag {{{
awful.layout.layouts = {
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.sw,
    awful.layout.suit.corner.se,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating,
    awful.layout.suit.magnifier
}
-- }}}

-- -------------------------------------------------------------------------------------
-- Setting a Wallpaper

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end

        awful.spawn.with_shell("feh --bg-fill " .. wallpaper)
    end
end

-- Set wallpaper on screen's geometry changes
screen.connect_signal("property::geometry", set_wallpaper)

-- -------------------------------------------------------------------------------------
-- Creating Tags

awful.screen.connect_for_each_screen(
    function(s)
        -- Set wallpaper for every screen
        set_wallpaper(s)

        handlers.connect_for_each_screen(s)

        -- Each screen has its own tag table.
        -- Layouts
        local l = awful.layout.suit

        -- Creating tags with separate configurations {{{
        awful.tag.add(
            tagnames[1],
            {
                layout = l.max,
                screen = s,
                selected = true
                -- Work::Browser
            }
        )
        awful.tag.add(
            tagnames[2],
            {
                layout = l.spiral.dwindle,
                screen = s
                -- Work::Code
            }
        )
        awful.tag.add(
            tagnames[3],
            {
                layout = l.spiral.dwindle,
                screen = s
                -- Work::Reading
            }
        )
        awful.tag.add(
            tagnames[4],
            {
                layout = l.fair,
                screen = s
                -- Work::Terminal
            }
        )
        awful.tag.add(
            tagnames[5],
            {
                layout = l.max,
                screen = s
                -- Leisure::Browser
            }
        )
        awful.tag.add(
            tagnames[6],
            {
                layout = l.max,
                screen = s
                -- Leisure::Chill
            }
        )
        -- }}}
    end
)

-- -------------------------------------------------------------------------------------
-- Connect Handlers for Clients

-- Manage client handlers {{{
client.connect_signal(
    "manage",
    function(c)
        if not awesome.startup then
            -- Sets all new clients as slaves
            awful.client.setslave(c)
        end
        if
            (awesome.startup and not c.size_hints.user_position and
                not c.size_hints.program_position)
         then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end

        -- Fixes wrong geometry when titlebars are enabled
        if c.fullscreen then
            gears.timer.delayed_call(
                function()
                    if c.valid then
                        c:geometry(c.screen.geometry)
                    end
                end
            )
        end

        handlers.client_connect_manage(c)
    end
)
-- }}}

-- Focus change handlers {{{
client.connect_signal(
    "focus",
    function(c)
        handlers.client_connect_focus(c)
    end
)
client.connect_signal(
    "unfocus",
    function(c)
        handlers.client_connect_unfocus(c)
    end
)
-- }}}

-- Make rofi able to unminimize minimized clients {{{
-- Note: causes clients to unminimize after restarting awesome
client.connect_signal(
    "request::activate",
    function(c, context, hints)
        if c.minimized then
            c.minimized = false
        end
        awful.ewmh.activate(c, context, hints)
    end
)
-- }}}

-- Fullscreen handler {{{
client.connect_signal(
    "property::fullscreen",
    function(c)
        handlers.client_connect_fullscreen(c)
    end
)
-- }}}

-- -------------------------------------------------------------------------------------
-- Adding Awful Rules for Clients

awful.rules.rules = {
    -- Default properties {{{
    {
        rule = {},
        properties = {
            keys = keys.clientkeys,
            focus = awful.client.focus.filter,
            raise = true,
            screen = awful.screen.preferred,
            buttons = keys.clientbuttons,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            border_width = beautiful.window_border_width,
            border_color = beautiful.window_border_normal,
            honor_padding = true,
            honor_workarea = true,
            size_hints_honor = false,
            titlebars_enabled = true
        }
    },
    -- }}}

    -- Forced disable titlebars {{{
    {
        rule_any = {
            name = {
                "Chrome",
                "Chromium"
            },
            class = {
                "qutebrowser"
            }
        },
        properties = {titlebars_enabled = false}
    },
    -- }}}

    -- Floating {{{
    {
        rule_any = {
            class = {
                "Lxappearance",
                "Pavucontrol",
                "Alarm-clock-applet"
            },
            role = {
                "pop-up"
            }
        },
        properties = {floating = true, ontop = false}
    },
    -- }}}

    -- Centered {{{
    {
        rule_any = {
            type = {
                "dialog"
            },
            name = {
                "Save As",
                "Open File",
                "File Upload",
                "Select a filename",
                "Enter name of file to save to…",
                "Library"
            },
            role = {
                "GtkFileChooserDialog"
            }
        },
        properties = {},
        callback = function(c)
            awful.placement.centered(c, {honor_workarea = true})
        end
    },
    -- }}}

    -- Forced titlebars {{{
    {
        rule_any = {
            name = {
                "Save As",
                "Open File",
                "File Upload",
                "Select a filename",
                "Enter name of file to save to…",
                "Library"
            },
            role = {
                "GtkFileChooserDialog"
            }
        },
        properties = {},
        callback = function(c)
            awful.titlebar.show(c, beautiful.titlebar.position)
        end
    }
    -- }}}
}

-- -------------------------------------------------------------------------------------
-- Running Autostart Script

awful.spawn.with_shell(scripts_dir .. "autostart.sh")
