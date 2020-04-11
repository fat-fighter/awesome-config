-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful").startscreen.calculator

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the Calculator Widget

local calculator_icon = wibox.widget {
	image = beautiful.icon,
	resize = true,
	forced_width = beautiful.icon_size,
	forced_height = beautiful.icon_size,
	widget = wibox.widget.imagebox
}

local centered = helpers.centered

local calculator = wibox.widget {
	centered(
		centered(calculator_icon, "horizontal"),
		"vertical"
	),
	bg = beautiful.bg,
	shape = helpers.rrect(beautiful.border_radius),
	forced_width = beautiful.width,
	forced_height = beautiful.height,
	widget = wibox.container.background
}

helpers.add_clickable_effect(
	calculator,
	function()
		calculator.bg = beautiful.bg_hover
	end,
	function()
		calculator.bg = beautiful.bg
	end
)

-- -------------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

calculator:buttons(gears.table.join(
	-- Left click - Open calculator
	awful.button({}, 1, function()
		awful.spawn.with_shell("gnome-calculator")
	end)
))

-- -------------------------------------------------------------------------------------
return calculator
