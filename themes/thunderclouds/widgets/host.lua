-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful").startscreen.host

-- -------------------------------------------------------------------------------------
-- Creating the Final Widget

local host = {
	markup = io.popen("hostname"):read(),
	font = beautiful.font,
	widget = wibox.widget.textbox
}

-- -------------------------------------------------------------------------------------

return {
	host,
	{
		wibox.widget.textbox(),
		bg = "#ffffffaa",
		forced_height = 2,
		widget = wibox.widget.background
	},
	layout = wibox.layout.fixed.vertical
}
