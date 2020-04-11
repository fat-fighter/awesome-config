-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful").startscreen.screenshot

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the Screenshot Widget

local screenshot_icon = wibox.widget {
	image = beautiful.icon,
	resize = true,
	forced_width = beautiful.icon_size,
	forced_height = beautiful.icon_size,
	widget = wibox.widget.imagebox
}

local centered = helpers.centered

local screenshot = wibox.widget {
	centered(
		centered(screenshot_icon, "horizontal"),
		"vertical"
	),
	bg = beautiful.bg,
	shape = helpers.rrect(beautiful.border_radius or 0),
	forced_width = beautiful.width,
	forced_height = beautiful.height,
	widget = wibox.container.background
}

helpers.add_clickable_effect(
	screenshot,
	function()
		screenshot.bg = beautiful.bg_hover
	end,
	function()
		screenshot.bg = beautiful.bg
	end
)

-- -------------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

screenshot:buttons(gears.table.join(
	-- Left click - Take screenshot
	awful.button({}, 1, function()
		awful.spawn.with_shell("gnome-screenshot -f ~/downloads/screenshot.png")
	end),
	-- Right click - Take screenshot in 5 seconds
	awful.button({}, 3, function()
		naughty.notify({
            title = "Say cheese!",
            text = "Taking shot in 5 seconds",
            timeout = 4, icon = beautiful.icon
        })
		awful.spawn.with_shell(
            "sleep 5 && gnome-screenshot -f ~/downloads/screenshot.png"
        )
	end)
))

-- -------------------------------------------------------------------------------------
return screenshot
