-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local wibox = require("wibox")
local vicious = require("vicious")
local beautiful = require("beautiful").startscreen.datetime

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating Different Timezones

local timezones = {
	{
		location = "New York, NY",
		offset = 0
	},
	{
		location = "Kanpur, UP",
		offset = 34200
	}
}


-- -------------------------------------------------------------------------------------
-- Creating the Time and Date Widgets

local time_blocks = {}
local colorize = helpers.colorize_text

for i = 1, #timezones do
	local time = wibox.widget.textbox()
	local date = wibox.widget.textbox()
	local location = wibox.widget.textbox()

	time.font = beautiful.time.font
	date.font = beautiful.date.font
	location.font = beautiful.location.font

	time.align = "center"
	date.align = "center"
	location.align = "center"

	vicious.register(
        time,
        vicious.widgets.date,
        colorize("%H %M", beautiful.date.fg),
        2,
        timezones[i].offset
    )
	vicious.register(date, vicious.widgets.date, "%A %b %d", 2, timezones[i].offset)

	location.markup = colorize(timezones[i].location, beautiful.location.fg)

	time_blocks[i] = wibox.widget {
		{
			location,
			helpers.vpad(1),
			time,
			date,
			layout = wibox.layout.fixed.vertical
	},
		margins = beautiful.timeblock.margin, 
		widget = wibox.container.margin
	}

	i = i + 1
end

time_blocks.layout = wibox.layout.fixed.vertical

-- -------------------------------------------------------------------------------------
-- Creating the Final Widget

local datetime = wibox.widget {
	time_blocks,
	layout = wibox.layout.fixed.vertical
}

-- -------------------------------------------------------------------------------------
return datetime
