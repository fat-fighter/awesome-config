--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful").startscreen.notes

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

--------------------------------------------------------------------------------
-- Creating the Widget

local title = wibox.widget {
	font   = beautiful.title.font,
	align  = "left",
	valign = "center",
	markup = helpers.colorize_text("Notes", beautiful.title.fg),
	widget = wibox.widget.textbox
}

local text  = wibox.widget {
	widget = wibox.container.background
}

local edit  = wibox.widget {
	image         = beautiful.edit_icon,
	forced_width  = beautiful.edit_icon_size,
	forced_height = beautiful.edit_icon_size,
	widget        = wibox.widget.imagebox
}

local notes = {
	{
		{
			title, nil, edit,
			layout = wibox.layout.align.horizontal
		},
		{
			helpers.vpad(0.2),
			color  = beautiful.title.fg .. "99",
			bottom = 1,
			widget = wibox.container.margin
		},
		helpers.vpad(0.4),
		text,
		layout = wibox.layout.fixed.vertical
	},
	margins = beautiful.margin,
	widget  = wibox.container.margin
}

--------------------------------------------------------------------------------
-- Adding Update Function

local function get_markup(line)
	if line:sub(1, 1) == "#" then
		return helpers.colorize_text(line:sub(2, -1), beautiful.text.heading_fg)
	end

	return line
end

local function update_widget()
	awful.spawn.easy_async_with_shell(
		"cat ~/todo",
		function (stdout)
			local textboxes = {}
			for line in stdout:gmatch("[^\r\n]+") do
    			table.insert(
					textboxes,
					wibox.widget {
						markup        = get_markup(line),
						font          = beautiful.text.font,
						forced_height = beautiful.line_height,
						widget        = wibox.widget.textbox
					}
				)
			end
			textboxes.layout = wibox.layout.fixed.vertical
			text:setup(textboxes)
		end
	)
end

local timer = gears.timer {
    timeout   = 120,
	call_now  = true,
    autostart = true,
    callback  = update_widget
}

--------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

edit:buttons(gears.table.join(
	-- Left click - Open google mail
	awful.button({ }, 1, function ()
		awful.spawn.with_shell(editor .. " ~/todo")
	end)
))

--------------------------------------------------------------------------------
return notes
