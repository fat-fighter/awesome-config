--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful").startscreen.calendar

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

--------------------------------------------------------------------------------
-- Creating Control Buttons for the Widget

local left_powerline = function(cr, _, _)
	return gears.shape.powerline(cr, beautiful.buttons_size, beautiful.buttons_size, -beautiful.buttons_depth)
end
local right_powerline = function(cr, _, _)
    return gears.shape.powerline(cr, beautiful.buttons_size, beautiful.buttons_size, beautiful.buttons_depth)
end

local prev_button = wibox.widget {
	bg            = beautiful.fg["header"] or "#DDDDDD",
	shape         = left_powerline,
	forced_width  = beautiful.buttons_size,
	forced_height = beautiful.buttons_size,
	widget        = wibox.container.background
}
prev_button:setup {
	nil,
	layout = wibox.layout.fixed.vertical
}

local next_button = wibox.widget {
	bg            = beautiful.fg["header"] or "#DDDDDD",
	shape         = right_powerline,
	forced_width  = beautiful.buttons_size,
	forced_height = beautiful.buttons_size,
	widget        = wibox.container.background
}
next_button:setup {
	nil,
	layout = wibox.layout.fixed.vertical
}

--------------------------------------------------------------------------------
-- Creating Styles for Different Cell Types

local function decorate_cell(widget, flag, date)
	local weekend = false
	if flag == "normal" or flag == "weekday" or flag == "focus" then	
		local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
    	local weekday = tonumber(os.date("%w", os.time(d)))
    	
		weekend = weekday % 6 == 0
	end

	if weekend and flag ~= "focus" then
		if flag == "weekday" then
			flag = "weekend"
		else
			flag = "dweekend"
		end
	end

	if beautiful.markup and widget.get_text and widget.set_markup then
		widget:set_markup(beautiful.markup(widget:get_text(), flag))
	end

	widget.align  = "center"
	widget.valign = "center"

	if flag == "header" then
		widget = wibox.widget {
			prev_button,
			widget,
			next_button,
			layout = wibox.layout.align.horizontal
		}
	end

	return wibox.widget {
			{
				widget,
				margins = (beautiful.padding[flag] or 3) + (beautiful.border_width[flag] or 0),
				widget  = wibox.container.margin
			},
			shape              = beautiful.shape[flag],
			shape_border_color = beautiful.border_color[flag] or "#00000000",
			shape_border_width = beautiful.border_width[flag] or 3,
			fg                 = beautiful.fg[flag] or "#DDDDDD",
			bg                 = beautiful.bg[flag] or "#00000000",
			widget             = wibox.container.background
		}
end

--------------------------------------------------------------------------------
-- Creating the Calendar Widget

local calendar = wibox.widget {
    date          = os.date("*t"),
	font          = beautiful.font.weekday,
	spacing       = beautiful.spacing,
	fn_embed      = decorate_cell,
	long_weekdays = false,
    widget        = wibox.widget.calendar.month
}

--------------------------------------------------------------------------------
-- Adding Button Controls to the Calendar Widget

calendar:buttons(gears.table.join(
	-- Right Click - Reset date to current date
	awful.button({ }, 3, function ()
		calendar.date = os.date("*t")
	end),

	-- Scroll - Move to previous or next month
	awful.button({ }, 4, function ()
		local month = calendar.date.month - 1
		local today = os.date("*t")
		if month == today.month then
			calendar.date = today
		else
			calendar.date = {month = month, year = calendar.date.year}
		end
	end),
	awful.button({ }, 5, function ()
		local month = calendar.date.month + 1
		local today = os.date("*t")
		if month == today.month then
			calendar.date = today
		else
			calendar.date = {month = month, year = calendar.date.year} 
		end
	end)
))

prev_button:buttons(gears.table.join(
	-- Left Click - Move to previous month
	awful.button({ }, 1, function ()
		local month = calendar.date.month - 1
		local today = os.date("*t")
		if month == today.month then
			calendar.date = today
		else
			calendar.date = {month = month, year = calendar.date.year}
		end
	end)
))

next_button:buttons(gears.table.join(
	-- Left Click - Move to next month
	awful.button({ }, 1, function ()
		local month = calendar.date.month + 1
		local today = os.date("*t")
		if month == today.month then
			calendar.date = today
		else
			calendar.date = {month = month, year = calendar.date.year}
		end
	end)
))

--------------------------------------------------------------------------------
return calendar
