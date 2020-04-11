-- =====================================================================================
--   Name:       keys.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/thunderclouds/ ...
--               ... widgets/startscreen.lua
--   License:    The MIT License (MIT)
--
--   Widget for custom dashboard
-- =====================================================================================

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful").startscreen

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")
local animation = require("animation.animation")

-- -------------------------------------------------------------------------------------
-- Defining Helper Functions for Creating Startscreen

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

local function get_x(width)
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

-- -------------------------------------------------------------------------------------
-- Defining Function to Create a Startscreen

local function create_startscreen(screen)
    ----------------------------------------------------------------------------
    -- Creating the StartScreen

    local startscreen = wibox {visible = false, ontop = true, type = "dock"}

    local startscreen_bg =
        wibox.widget {
        helpers.empty_widget,
        opacity = beautiful.bg_opacity,
        widget = wibox.container.background
    }

    if beautiful.bg_image then
        local bg_image = gears.surface(beautiful.bg_image)
        local bg_width, bg_height = gears.surface.get_size(bg_image)

        local function bg_image_function(_, cr, width, height)
            cr:scale(width / bg_width, height / bg_height)
            cr:set_source_surface(bg_image)
            cr:paint()
        end

        startscreen_bg.bgimage = bg_image_function
    end

    startscreen.bg = beautiful.bg
    startscreen.fg = beautiful.fg or "#FFFFFF"

    if beautiful.border_radius then
        startscreen.shape = helpers.rrect(beautiful.border_radius)
    end

    ----------------------------------------------------------------------------
    -- Adding Toggle Controls with Animation to the Widget

    startscreen.animator = nil
    startscreen.visibility = false

    function startscreen:show(width, height, x, y)
        self.visibility = true

        width = width or get_width()
        height = height or get_height()

        self.width = width
        self.height = height

        x = x or get_x(width)
        y = y or get_y(height)

        if not self.animator then
            if beautiful.animation.style == "opacity" then
                -- Non-zero to avoid glitches with full-screen windows
                self.opacity = 0.01
            else
                self.opacity = beautiful.opacity
            end

            if beautiful.animation.style == "slide_tb" then
                self.x = x
                self.y = -height
            elseif beautiful.animation.style == "slide_lr" then
                self.x = -width
                self.y = y
            else
                self.x = x
                self.y = y
            end
        end

        self.visible = true

        if beautiful.animation.style ~= "none" then
            if self.animator then
                self.animator:stopAnimation()
            end

            self.animator =
                animation(
                self,
                beautiful.animation.duration,
                {
                    opacity = beautiful.opacity,
                    x = x,
                    y = y
                },
                beautiful.animation.easing
            )
            self.animator:startAnimation()
        end
    end

    function startscreen:hide(width, height, x, y)
        self.visibility = false

        if beautiful.animation.style ~= "none" then
            width = width or get_width()
            height = height or get_height()

            x = x or get_x(width)
            y = y or get_y(height)

            local target = {}

            if beautiful.animation.style == "opacity" then
                -- Non-zero to avoid glitches with full-screen windows
                target.opacity = 0.01
            else
                target.opacity = beautiful.opacity
            end

            if beautiful.animation.style == "slide_tb" then
                target.x = x
                target.y = -height
            elseif beautiful.animation.style == "slide_lr" then
                target.x = -width
                target.y = y
            else
                target.x = x
                target.y = y
            end

            if self.animator then
                self.animator:stopAnimation()
            end

            self.animator =
                animation(
                self,
                beautiful.animation.duration,
                target,
                beautiful.animation.easing
            )
            self.animator:startAnimation()

            self.animator:connect_signal(
                "anim::animation_finished",
                function()
                    self.visible = false
                end
            )
        else
            self.visible = false
        end
    end

    function startscreen:toggle()
        local width, height = get_width(), get_height()
        local x, y = get_x(width), get_y(height)

        if not self.visibility then
            self:show(width, height, x, y)
        else
            self:hide(width, height, x, y)
        end
    end

    ----------------------------------------------------------------------------
    -- Setting up the Layout of the StartScreen

    local dpi = require("beautiful").dpi
    local boxed = function(widget, width, height, ignore_center)
        return helpers.boxed(
            widget,
            width,
            height,
            ignore_center,
            beautiful.widgetbox.bg,
            beautiful.widgetbox.border_radius,
            beautiful.widgetbox.margin
        )
    end
    -- boxed = helpers.create_widget_box

    local boxes = {
        {
            -- Column: 1
            boxed(require("widgets.user"), beautiful.column_widths[1], dpi(500)),
            boxed(require("widgets.player"), beautiful.column_widths[1], dpi(310)),
            layout = wibox.layout.fixed.vertical
        },
        {
            -- Column: 2
            boxed(require("widgets.datetime"), beautiful.column_widths[2], dpi(450)),
            boxed(require("widgets.notes"), beautiful.column_widths[2], dpi(360), true),
            layout = wibox.layout.fixed.vertical
        },
        {
            -- Column: 3
            boxed(require("widgets.calendar"), beautiful.column_widths[3], dpi(510)),
            require("widgets.controls"),
            layout = wibox.layout.fixed.vertical
        },
        layout = wibox.layout.fixed.horizontal
    }

    boxes = helpers.centered(boxes)

    startscreen:setup {
        startscreen_bg,
        {
            {
                {
                    require("widgets.host"),
                    nil,
                    require("widgets.battery"),
                    expand = "none",
                    layout = wibox.layout.align.horizontal
                },
                layout = wibox.layout.fixed.vertical
            },
            top = dpi(5),
            left = dpi(10),
            right = dpi(10),
            widget = wibox.container.margin
        },
        {
            boxes,
            margins = beautiful.border_width or 0,
            color = beautiful.border_color,
            widget = wibox.container.margin
        },
        layout = wibox.layout.stack
    }

    ----------------------------------------------------------------------------
    return startscreen
end

-- -------------------------------------------------------------------------------------
return create_startscreen
