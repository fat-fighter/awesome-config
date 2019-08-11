--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful").startscreen
local dpi       = require("beautiful.xresources").apply_dpi

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers   = require("helpers")
local animation = require("animation.animation")

--------------------------------------------------------------------------------
-- Creating the StartScreen

local startscreen   = wibox { visible = false, ontop = true, type = "dock" }

if beautiful.bg_image then
	local bg_image = gears.surface(beautiful.bg_image)
	local bg_width, bg_height = gears.surface.get_size(bg_image)

	local function bg_image_function(_, cr, width, height)
		cr:scale(width / bg_width, height / bg_height)
		cr:set_source_surface(bg_image)
		cr:paint()
	end

	startscreen.bgimage = bg_image_function
else
	startscreen.bg = beautiful.bg or "#111111"
end

startscreen.fg = beautiful.fg or "#FFFFFF"

if beautiful.border_radius then
	startscreen.shape = helpers.rrect(beautiful.border_radius)
end

--------------------------------------------------------------------------------
-- Adding Toggle Controls with Animation to the Widget

startscreen.animator   = nil
startscreen.visibility = false

local function get_width()
	local width = beautiful.width

	if type(width) == "function" then
		width = width()
	else
		width = width or awful.screen.focused().geometry.width
	end

	return width + (beautiful.border_width or 0) * 2
end

local function get_height()
	local height = beautiful.height

	if type(height) == "function" then
		height = height()
	else
		height = height or awful.screen.focused().geometry.height
	end

	return height + (beautiful.border_width or 0) * 2
end

local function get_x()
	local x = beautiful.x
	
	if type(x) == "function" then
		x = x()
	else
		x = x or (awful.screen.focused().geometry.width - width) / 2
	end

	return x
end

local function get_y(height)
	local y = beautiful.y
	
	if type(y) == "function" then
		y = y()
	else
		y = y or (awful.screen.focused().geometry.height - height) / 2
	end

	return y
end

function startscreen:show(width, height, x, y)
	startscreen.visibility = true
	
	width  = width or get_width()
	height = height or get_height()

	startscreen.width  = width
	startscreen.height = height

	x = x or get_x(width)
	y = y or get_y(height)

	if not startscreen.animator then
		if beautiful.animation.style == "opacity" then
			startscreen.opacity = 0
		else
			startscreen.opacity = beautiful.opacity
		end

		if beautiful.animation.style == "slide_tb" then
			startscreen.x = x
			startscreen.y = - height
		elseif beautiful.animation.style == "slide_lr" then
			startscreen.x = - width
			startscreen.y = y
		else
			startscreen.x = x
			startscreen.y = y
		end	
	end

	startscreen.visible = true

	if beautiful.animation.style ~= "none" then
		if startscreen.animator then startscreen.animator:stopAnimation() end

		startscreen.animator = animation(
			startscreen,
			beautiful.animation.duration,
			{
				opacity = beautiful.opacity,
				x       = x,
				y       = y
			},
			beautiful.animation.easing
		)
		startscreen.animator:startAnimation()
	end
end

function startscreen:hide(width, height, x, y)
	startscreen.visibility = false
	
	if beautiful.animation.style ~= "none" then
		width  = width or get_width()
		height = height or get_height()

		x = x or get_x(width)
		y = y or get_y(height)

		local target = {}

		if beautiful.animation.style == "opacity" then
			target.opacity = 0
		else
			target.opacity = beautiful.opacity
		end

		if beautiful.animation.style == "slide_tb" then
			target.x = x
			target.y = - height
		elseif beautiful.animation.style == "slide_lr" then
			target.x = - width
			target.y = y
		else
			target.x = x
			target.y = y
		end

		if startscreen.animator then startscreen.animator:stopAnimation() end

		startscreen.animator = animation(
			startscreen,
			beautiful.animation.duration,
			target,
			beautiful.animation.easing
		)
		startscreen.animator:startAnimation()

		startscreen.animator:connect_signal(
			"anim::animation_finished",
			function() startscreen.visible = false end
		)
	else
		startscreen.visible = false
	end
end

function startscreen:toggle()
	local width, height = get_width(), get_height()
	local x, y          = get_x(width), get_y(height)

	if not startscreen.visibility then
		startscreen:show(width, height, x, y)
	else
		startscreen:hide(width, height, x, y)
	end
end

--------------------------------------------------------------------------------
-- Setting up the Layout of the StartScreen

local boxed    = helpers.create_widget_box
local centered = helpers.center_align_widget

startscreen:setup{
	{
		-- Center boxes vertically
		nil,
		centered({
			{
				-- Column: 1
				boxed(
					require("widgets.user"),
					beautiful.column_widths[1], dpi(500)
				),
				boxed(
					require("widgets.spotify"),
					beautiful.column_widths[1], dpi(300)
				),
				layout = wibox.layout.fixed.vertical
			},
			{
				-- Column: 2
				boxed(
					require("widgets.datetime"),
					beautiful.column_widths[2], dpi(450)
				),
				boxed(
					require("widgets.notes"),
					beautiful.column_widths[2], dpi(350), true
				),
				layout = wibox.layout.fixed.vertical
			},
			{
				-- Column: 3
				boxed(
					require("widgets.calendar"),
					beautiful.column_widths[3], dpi(502)
				),
				require("widgets.controls"),
				layout = wibox.layout.fixed.vertical
			},
			layout = wibox.layout.fixed.horizontal
		}, "horizontal"),
		nil,
		expand = "none",
		layout = wibox.layout.align.vertical
	},
	margins = beautiful.border_width or 0,
	color = beautiful.border_color or "#00000000",
	widget = wibox.container.margin
}

--------------------------------------------------------------------------------
return startscreen
