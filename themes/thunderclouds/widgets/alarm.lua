-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful").startscreen.alarm

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the Alarm Widget

local alarm_icon = wibox.widget {
	image = beautiful.icon,
	resize = true,
	forced_width = beautiful.icon_size,
	forced_height = beautiful.icon_size,
	widget = wibox.widget.imagebox
}

local centered = helpers.centered

local alarm = wibox.widget {
	centered(
		centered(alarm_icon, "horizontal"),
		"vertical"
	),
	bg = beautiful.bg,
	shape = helpers.rrect(beautiful.border_radius or 0),
	forced_width = beautiful.width,
	forced_height = beautiful.height,
	widget = wibox.container.background
}

helpers.add_clickable_effect(
	alarm,
	function()
		alarm.bg = beautiful.bg_hover
	end,
	function()
		alarm.bg = beautiful.bg
	end
)

-- -------------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

alarm:buttons(gears.table.join(
	-- Left click - Open alarm
	awful.button({}, 1, function()
		awful.spawn.with_shell("alarm-clock-applet")
	end)
))

-- -------------------------------------------------------------------------------------
return alarm
