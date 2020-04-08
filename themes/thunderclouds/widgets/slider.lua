-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful").startscreen.volume
local dpi = require("beautiful.xresources").apply_dpi

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating Volume Icon and Volume Slider

local slider = {}

function slider.create_slider(style, update_cmd)
	-- Creating the icon and slider bars
	local icon = wibox.widget {
		resize = true,
		forced_width = style.icon_size,
		forced_height = style.icon_size,
		widget = wibox.widget.imagebox
	}

	local bar = wibox.widget {
		value = 0,
		maximum = 100,
		bar_shape = helpers.rrect(style.border_radius),
		bar_height = style.width,
		bar_color = "#00000000",
		handle_color = style.controller_bg,
		handle_shape = gears.shape.rect,
		handle_border_color = style.controller_bg,
		handle_width = 0,
		handle_border_width = 0,
		forced_width = style.height,
		forced_height = style.width,
		enabled = true,
		widget = wibox.widget.slider
	}

	local cover = wibox.widget {
		bg = style.controller_bg,
		shape = helpers.rrect(style.border_radius),
		forced_width = style.width,
		widget = wibox.container.background
	}
	cover:setup {
		nil,
		layout = wibox.layout.align.vertical
	}

	-- Creating the widget
	local widget = wibox.widget {
		{
			bar,
			direction = "east",
			widget = wibox.container.rotate
	},
		{
			{
				nil, nil,
				cover,
				layout = wibox.layout.align.vertical
	},
			bg = style.bar_bg,
			shape = helpers.rrect(style.border_radius),
			forced_width = style.width,
			widget = wibox.container.background
	},
		{
			nil, nil,
			{
				helpers.center_align_widget(
					icon, "horizontal"
				),
				bottom = style.icon_bottom,
				layout = wibox.container.margin
	},
			layout = wibox.layout.align.vertical
	},
		layout = wibox.layout.stack
	}

	-- Adding local variables to widget
	widget.bar = bar
	widget.icon = icon
	widget.cover = cover

	-- Adding update signals {{
	--   In order to make this work, an extra *hack* line needs to be added in
	--   the slider.lua file (/usr/share/awesome/lib/wibox/widget)
	--   >> self:emit_signal("button::release", 42, 42, 1, {}, geo)
	--   The above line must be added in the function "mouse_press". Diff ->
	--       capi.mousegrabber.run(function(mouse)
	--           if not mouse.buttons[1] then
	--   +            self:emit_signal("button::release", 42, 42, 1, {}, geo)
	--               return false
	--           end
	-- }}
	bar:connect_signal("button::release", function(_, _, _, button, _, _)
		if button == 1 and bar.enabled == true then
			awful.spawn.with_shell(update_cmd .. " " .. bar.value)
		end
	end)
	bar:connect_signal("property::value", function()
		cover.forced_height = dpi(bar.value * style.scale)
	end)

	return widget
end

-- -------------------------------------------------------------------------------------
return slider
