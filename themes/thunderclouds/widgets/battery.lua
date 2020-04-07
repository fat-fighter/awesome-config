--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local wibox     = require("wibox")
local gears     = require("gears")
local vicious   = require("vicious")
local beautiful = require("beautiful").startscreen.battery

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")
local naughty = require("themes." .. theme_name .. ".components.notify")

--------------------------------------------------------------------------------
-- Creating the Time and Date Widgets

local semicircle = function(cr, width, height)
	return gears.shape.pie(cr, width, height, -math.pi/2, math.pi/2)
end

local perc = wibox.widget {
	font          = beautiful.font,
	color         = beautiful.fg_normal,
	valign        = "center",
	forced_height = beautiful.height,
	widget        = wibox.widget.textbox
}
local bar  = wibox.widget {
	color            = beautiful.fg_normal,
	value            = 0,
	shape            = helpers.rrect(beautiful.radius),
	bar_shape        = helpers.rrect(beautiful.radius),
	max_value        = 100,
	border_color     = beautiful.border.color,
	border_width     = beautiful.border.width,
	forced_width     = beautiful.width,
	forced_height    = beautiful.height,
	background_color = "#00000000",
	widget           = wibox.widget.progressbar
}

local notified = false

vicious.register(
	perc,
	vicious.widgets.bat,
	function (_, args)
		value = args[2]
		bar.value = value

		bar.color = beautiful.fg_normal

		state = args[1]
		if state == "-" then
			if value <= beautiful.low_thresh then
				bar.color = beautiful.fg_urgent
				
				if not notified then
					naughty.notify({
						title = "Low Battery",
						text  = "The current battery percentage is lower than " .. tostring(beautiful.low_thresh) .. "%. Please charge",
						icon  = beautiful.low_icon
					})
					notified = true
				end
			end
		else
			bar.color = beautiful.fg_charging
		end

		return tostring(value) .. "% "
	end,
	61,
	"BAT0"
)

local decoration = wibox.widget {
	{
		{
			markup = "",
			font = beautiful.font,
			widget = wibox.widget.textbox
		},
		bg     = "#ffffff",
		shape  = semicircle,
		forced_height = beautiful.decoration,
		forced_width = beautiful.decoration,
		widget = wibox.container.background
	},
	left = -beautiful.decoration * 0.3,
	widget = wibox.container.margin
}

--------------------------------------------------------------------------------
-- Creating the Final Widget

local battery = helpers.center_align_widget(
	{
		perc,
		bar,
		decoration,
		forced_height = beautiful.height,
		widget = wibox.container.background,
		layout = wibox.layout.fixed.horizontal
	},
	"vertical"
)

--------------------------------------------------------------------------------

return battery
