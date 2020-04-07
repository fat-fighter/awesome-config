--   ██████             ██
--  ░███░░██           ░██
--  ░███ ░░   █████    █████         █████    ████    ██    ███   █████    ████   █████   █████████████    █████
--  █████    ░░░░░██  ░░███         ░░░░░██  ░░███   ████   ██   ███░░██ ░███░   ███░░██ ░░███░░███░░██   ███░░██
-- ░░███      ██████   ░██     ████  ██████   ░░███ ██████ ██   ░██████   ░███  ░███ ░██  ░███ ░███ ░██  ░██████
--  ░██      ███░░██   ░███   ░░░░  ███░░██    ░░█████░░████    ░███░░    ░░░██ ░███ ░██  ░███ ░███ ░██  ░███░░
--  ████     ░███████  ░░███        ░███████    ░░███  ░░██     ░░██████  ████  ░░█████   █████░███ ████ ░░██████
-- ░░░░      ░░░░░░░    ░░░         ░░░░░░░      ░░░    ░░       ░░░░░░  ░░░░    ░░░░░   ░░░░░ ░░░ ░░░░   ░░░░░░
----------------------------------------------------------------------------------------------------

do
    -- Choosing awful theme
    local theme_collection = {
        "thunderclouds",      -- 1 --
    }

    -- Change this number to use a different theme
    theme_name = theme_collection[1]
end

--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

require("awful.autofocus")

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

--------------------------------------------------------------------------------
-- Defining Global Variables

editor      = "gvim"
terminal    = "termite"
filemanager = terminal .. "-e ranger"

ntags       = 8

config_dir  = os.getenv("HOME") .. "/.config/awesome/"

--------------------------------------------------------------------------------
-- Initializing the Theme

theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/"

local beautiful = require("beautiful")

if not beautiful.init(theme_dir .. "theme.lua") then
    naughty.notify({
        text   = "Error loading theme " .. theme_name .. " from " .. theme_dir,
        preset = naughty.config.presets.critical
    })
end

--------------------------------------------------------------------------------
-- Running Cleanup Script

os.execute(config_dir .. "scripts/cleanup.sh")

--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

package.path = package.path .. ";" .. theme_dir .. "?.lua"

local keys     = require("keys")
local helpers  = require("helpers")
local naughty  = require("components.notify")
local handlers = require("handlers")

require("components.titlebar")

--------------------------------------------------------------------------------
-- Error Handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify {
		text   = awesome.startup_errors,
		title  = "Oops, there were errors during startup!",
		preset = naughty.config.presets.critical
	}
end

-- Handle runtime errors after startup {{
do
	local in_error = false
	awesome.connect_signal(
		"debug::error",
		function (err)
			if in_error then return end
			in_error = true

			naughty.notify {
				text   = tostring(err),
				title  = "Oops, an error happened!",
				preset = naughty.config.presets.critical
			}
			in_error = false
		end
	)
end
-- }}

--------------------------------------------------------------------------------
-- Choosing Possible Layouts
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
	awful.layout.suit.magnifier,
}

--------------------------------------------------------------------------------
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

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

--------------------------------------------------------------------------------
-- Creating Tags

awful.screen.connect_for_each_screen(function(s)
	-- Set wallpaper for every screen
	set_wallpaper(s)

    handlers.connect_for_each_screen(s)

	-- Each screen has its own tag table.
	-- Layouts
	local l = awful.layout.suit

	-- Creating tags with separate configurations
	awful.tag.add(tagnames[1], {
		layout = l.max,
		screen = s,
		selected = true,
		-- Work::Browser
	})
	awful.tag.add(tagnames[2], {
		layout = l.spiral.dwindle,
		screen = s,
		-- Work::Writing
	})
	awful.tag.add(tagnames[3], {
		layout = l.spiral.dwindle,
		screen = s,
		-- Work::Reading
	})
	awful.tag.add(tagnames[4], {
		layout = l.fair,
		screen = s,
		-- Work::Terminal
	})
	awful.tag.add(tagnames[5], {
		layout = l.max,
		screen = s,
		-- Work::Code
	})
	awful.tag.add(tagnames[6], {
		layout = l.max,
		screen = s,
		-- Leisure::Videos
	})
	awful.tag.add(tagnames[7], {
		layout = l.max,
		screen = s,
		-- Leisure::Music
	})
	awful.tag.add(tagnames[8], {
		layout = l.max,
		screen = s,
		-- Leisure::Social
	})
end)

--------------------------------------------------------------------------------
-- Connect Handlers for Clients

client.connect_signal("manage", function (c)
	-- Set every new window as a slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	else
		if not (c.size_hints.user_position or c.size_hints.program_position) then
	   		-- Prevent clients from being unreachable after screen count changes.
	   		awful.placement.no_offscreen(c)
		end
	end

	-- If the layout is not floating, every floating client that appears is centered
	if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
		awful.placement.centered(c, { honor_workarea = true })
	else
		-- If the layout is floating, and there is no other client visible, center it
		if #mouse.screen.clients == 1 then
			awful.placement.centered(c, { honor_workarea = true })
		end
	end
    
    -- Fixes wrong geometry when titlebars are enabled
    if c.fullscreen then
        gears.timer.delayed_call(function()
            if c.valid then
                c:geometry(c.screen.geometry)
            end
        end)
    end
        
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, "floating_geometry", c:geometry())
    end

    handlers.client_connect_manage(c)
end)

client.connect_signal("focus", function(c) handlers.client_connect_focus(c) end)
client.connect_signal("unfocus", function(c) handlers.client_connect_unfocus(c) end)

client.connect_signal(
	"property::geometry",
    function(c)
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            awful.client.property.set(c, "floating_geometry", c:geometry())
        end
    end
)

-- Make rofi able to unminimize minimized clients
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

client.connect_signal("property::fullscreen", function (c) handlers.client_connect_fullscreen(c) end)

--------------------------------------------------------------------------------
-- Connect Handlers for Tags

tag.connect_signal(
	"property::layout",
    function(t)
        for k, c in ipairs(t:clients()) do
            if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
                local cgeo = awful.client.property.get(c, "floating_geometry")
                if cgeo ~= nil then
                    if not (cgeo.x == 0 and cgeo.y == 0) then
                        c:geometry(awful.client.property.get(c, "floating_geometry"))
                    end
                end
            end
        end
    end
)

--------------------------------------------------------------------------------
-- Adding Awful Rules for Clients

awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = { },
		properties = {
			keys             = keys.clientkeys,
			focus            = awful.client.focus.filter,
			raise            = true,
			screen           = awful.screen.preferred,
			buttons          = keys.clientbuttons,
			placement        = awful.placement.no_overlap + awful.placement.no_offscreen,
			border_width     = beautiful.window_border_width,
			border_color     = beautiful.window_border_normal,
			honor_padding    = true,
			honor_workarea   = true,
			size_hints_honor = false
		}
	},

    -- Add titlebars to normal clients and dialogs
	{
		rule_any   = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = true },
    },

	-- Turn off titlebars for some clients
	{
        rule_any = {
			name = {
				"Chrome",
				"Chromium",
			},
            class = {
                "qutebrowser",
            },
        },
        properties = { titlebars_enabled = false },
    },

	-- Floating clients
	{
		rule_any   = {
			class = {
				"Lxappearance",
				"Pavucontrol",
				"Alarm-clock-applet",
			},
			role  = {
				"pop-up",
			}
		},
		properties = { floating = true, ontop = false }
	},

	-- Centered clients
	{
		rule_any   = {
			type = {
				"dialog",
			},
			name = {
				"Save As",
				"Open File",
				"File Upload",
				"Select a filename",
				"Enter name of file to save to…",
				"Library",
			},
			role = {
				"GtkFileChooserDialog",
			}
		},
		properties = {},
		callback   = function(c)
			awful.placement.centered(c, { honor_workarea = true })
		end
	},

	-- Centered clients with forced titlebars
	{
		rule_any   = {
			name = {
				"Save As",
				"Open File",
				"File Upload",
				"Select a filename",
				"Enter name of file to save to…",
				"Library",
			},
			role = {
				"GtkFileChooserDialog",
			}
		},
		properties = {},
		callback   = function(c)
			awful.titlebar.show(c, beautiful.titlebar.position)
		end
	},

	{
		rule_any   = { class = { "code-git" } },
      	properties = { tag = "5" }
	},
	{
		rule_any   = { class = { "Skype Preview" } },
    	properties = { tag = "8" }
	},
}

--------------------------------------------------------------------------------
-- Running Autostart Script

awful.spawn.with_shell(config_dir .. "scripts/autostart.sh")
