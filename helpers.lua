--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local naughty   = require("naughty")
local beautiful = require("beautiful")
local cairo     = require("lgi").cairo
local dpi       = require("beautiful.xresources").apply_dpi

local helpers = {}

--------------------------------------------------------------------------------
-- Adding Shape Functions

-- Rectangle
helpers.rect = function()
	return gears.shape.rectangle
end

-- Rounded rectangle
helpers.rrect = function(radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end

-- Partially rounded rectangle
helpers.prrect = function(radius, tl, tr, br, bl)
	return function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
	end
end

-- Rounded bar
helpers.rbar = function()
	return gears.shape.rounded_bar
end

-- Info bubble
helpers.infobubble = function(radius, arrow_placement, arrow_size, arrow_position)
	local transform  = gears.shape.transform
	local infobubble = gears.shape.infobubble

	local degs = {
		up     = 0,
		right  = 1,
		bottom = 2,
		left   = 3
	}
	local deg = degs[arrow_placement or "up"]

	return function(cr, width, height)
		transform(infobubble):rotate_at(width / 2, height / 2, deg * math.pi)(
			cr, width, height, radius, arrow_size, arrow_position
		)
	end
end

--------------------------------------------------------------------------------
-- Adding Titlebar Helpers

function helpers.create_titlebar(c, titlebar_buttons, titlebar_position, titlebar_size)
	awful.titlebar(c, {font = beautiful.titlebar_font, position = titlebar_position, size = titlebar_size}) : setup {
		{
			buttons = titlebar_buttons,
			layout  = wibox.layout.fixed.horizontal
		},
		{
			buttons = titlebar_buttons,
			layout  = wibox.layout.fixed.horizontal
		},
		{
			buttons = titlebar_buttons,
			layout = wibox.layout.fixed.horizontal
		},
		layout = wibox.layout.align.horizontal
	}
end

--------------------------------------------------------------------------------
-- Adding Client Helpers

function helpers.move_client_to_edge(c, direction)
    local workarea = awful.screen.focused().workarea
    local client_geometry = c:geometry()
    if direction == "up" then
        c:geometry({ nil, y = workarea.y + beautiful.screen_margin * 2, nil, nil })
    elseif direction == "down" then 
        c:geometry({ nil, y = workarea.height + workarea.y - client_geometry.height - beautiful.screen_margin * 2 - beautiful.border_width * 2, nil, nil })
    elseif direction == "left" then 
        c:geometry({ x = workarea.x + beautiful.screen_margin * 2, nil, nil, nil })
    elseif direction == "right" then 
        c:geometry({ x = workarea.width + workarea.x - client_geometry.width - beautiful.screen_margin * 2 - beautiful.border_width * 2, nil, nil, nil })
    end
end

--------------------------------------------------------------------------------
-- Adding Mouse Helpers

local double_tap_timer = nil
function helpers.single_double_tap(single_tap_function, double_tap_function)
	if double_tap_timer then
		double_tap_timer:stop()
		double_tap_timer = nil
		double_tap_function()
		return
	end

	double_tap_timer =
	gears.timer.start_new(0.20, function()
		double_tap_timer = nil
		single_tap_function()
		return false
	end)
end

--------------------------------------------------------------------------------
-- Adding Wibox Widget Helpers

function helpers.get_empty_widget()
    return {
        text   = "",
        widget = wibox.widget.textbox
    }
end

function helpers.center_align_widget(widget, direction)
	local layout
	if direction == "vertical" then
		layout = wibox.layout.align.vertical
	else
		layout = wibox.layout.align.horizontal
	end

	return wibox.widget {
		nil, widget, nil,
		expand = "none",
		layout = layout
	}
end

function helpers.create_widget_box(widget, width, height, ignore_center, bg, br)
	local style = beautiful.startscreen.widgetbox

	local box_container = wibox.container.background()

	box_container.bg            = bg or style.bg or "#333333"
	box_container.shape         = helpers.rrect(br or style.border_radius or 0)
	box_container.forced_width  = width
	box_container.forced_height = height

	local centered = helpers.center_align_widget

	if not ignore_center then
		widget = centered(
			centered(widget, "horizontal"), "vertical"
		)
	end

	return wibox.widget {
		{
			widget,
			widget = box_container,
        },
        margins = style.margin,
        color = "#00000000",
        widget = wibox.container.margin
    }
end

function helpers.add_clickable_effect(widget, press_callback, release_callback)
	widget:connect_signal("mouse::enter", press_callback)
	widget:connect_signal("mouse::leave", release_callback)
end

--------------------------------------------------------------------------------
-- Adding Padding Helpers

function helpers.hpad(size)
	local str = ""
	for i = 1, size do
		str = str .. " "
	end
	local pad = wibox.widget.textbox(str)
	pad.font = "sans 13"
	return pad
end

function helpers.vpad(size)
	local pad = wibox.widget.textbox(" ")
	pad.font = "sans " .. tostring(13 * size)

	return pad
end

--------------------------------------------------------------------------------
-- Adding Markup Helpers

function helpers.colorize_text(text, fg)
	return "<span foreground='" .. fg .."'>" .. text .. "</span>"
end

--------------------------------------------------------------------------------
-- Adding Shadow Widget

function helpers.add_shadow(widget, w, h, s, br, col)
    w = w + 2 * s
    h = h + 2 * s

    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, w, h)
    local cr  = cairo.Context(img)

    local r, g, b, a = gears.color.parse_color(col)
    local off = s + br

    local corners = {
        {off, off, 0, 0},
        {w - off, off, w - off, 0},
        {w - off, h - off, w - off, h - off},
        {off, h - off, 0, h - off}
    }
    local sides = {
        { {0, s, 0, 0}, {off, 0, w - 2 * off, s} },
        { {w - s, 0, w, 0}, {w - s, off, s, h - 2 * off} },
        { {s, h - s, s, h}, {off, h - s, w - 2 * off, s} },
        { {s, 0, 0, 0}, {0, off, s, h - 2 * off} },
    }

    for _, c in ipairs(corners) do
        local pat = cairo.RadialPattern(c[1], c[2], br, c[1], c[2], off)
        pat:add_color_stop_rgba(0, r, g, b, 0);
        pat:add_color_stop_rgba(0, r, g, b, a); -- To handle a bug in cairo
        pat:add_color_stop_rgba(1, r, g, b, 0);

        cr:rectangle(c[3], c[4], off, off)
        cr:set_source(pat)
        cr:fill()
    end

    for _, side in ipairs(sides) do
        local pat = cairo.LinearPattern(unpack(side[1]))
        pat:add_color_stop_rgba(0, r, g, b, a);
        pat:add_color_stop_rgba(1, r, g, b, 0);

        cr:rectangle(unpack(side[2]))
        cr:set_source(pat)
        cr:fill()
    end

    return {
        {
            widget,
            margins = s,
            widget  = wibox.container.margin
        },
        bgimage       = img,
        forced_width  = w,
        forced_height = h,
        widget        = wibox.container.background
    }
end

--------------------------------------------------------------------------------
return helpers
