--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful").systray

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

--------------------------------------------------------------------------------
-- Creating the Widget

local systray_container = wibox.widget {
	wibox.widget.systray(),
	margins = beautiful.margin,
	widget  = wibox.container.margin
}

local systray = wibox {
	ontop   = true,
	shape   = helpers.rrect(beautiful.border_radius),
	opacity = beautiful.opacity,
	visible = false,
	type    = "dock"
}

systray.bg     = beautiful.bg

systray.width  = beautiful.width
systray.height = beautiful.height

systray:setup {
	systray_container,
	layout = wibox.layout.fixed.horizontal
}

--------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

systray:buttons(gears.table.join(
	-- Middle click - Hide systray
	awful.button({ }, 2, function ()
		systray.visible = false
	end)
))

--------------------------------------------------------------------------------
-- Adding Connect Signals to the Widget

systray:connect_signal(
	"property::visible",
	function()
		if systray.visible then
			if type(beautiful.x) == "function" then
				systray.x = beautiful.x()
			else
				systray.x = beautiful.x or 0
			end
			
			if type(beautiful.y) == "function" then
				systray.y = beautiful.y()
			else
				systray.y = beautiful.y or 0
			end
		end
	end
)

--------------------------------------------------------------------------------
return systray
