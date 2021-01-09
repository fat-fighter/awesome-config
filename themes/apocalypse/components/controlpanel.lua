-- =====================================================================================
--   Name:       controlpanel.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/ ...
--               ... components/controlpanel.lua
--   License:    The MIT License (MIT)
--
--   Widget for custom dashboard
-- =====================================================================================

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful").controlpanel

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")
local animation = require("modules.animation")

-- -------------------------------------------------------------------------------------
-- Defining Helper Functions for Creating Startscreen

local function get_width(screen)
    local width = beautiful.width

    if type(width) == "function" then
        width = width(screen)
    end

    screen = screen or awful.screen.focused()
    width = width or screen.workarea.width

    width = width + (beautiful.border.left or 0)
    width = width + (beautiful.border.right or 0)

    return width
end

local function get_height(screen)
    local height = beautiful.height

    if type(height) == "function" then
        height = height(screen)
    end

    screen = screen or awful.screen.focused()
    height = height or screen.workarea.height

    height = height + (beautiful.border.top or 0)
    height = height + (beautiful.border.bottom or 0)

    return height
end

local function get_x(screen, width)
    local x = beautiful.x

    screen = screen or awful.screen.focused()

    if type(x) == "function" then
        x = x(screen)
    else
        x = x or (screen.workarea.width - width) / 2
    end

    return screen.workarea.x + x
end

local function get_y(screen, height)
    local y = beautiful.y

    screen = screen or awful.screen.focused()

    if type(y) == "function" then
        y = y(screen)
    else
        y = y or (screen.workarea.height - height) / 2
    end

    return screen.workarea.y + y
end

-- -------------------------------------------------------------------------------------
-- Defining Function to Create a Startscreen

local function create_controlpanel(screen)
    ----------------------------------------------------------------------------
    -- Creating the StartScreen

    local controlpanel =
        wibox {
        visible = true,
        ontop = true,
        bg = beautiful.bg,
        fg = beautiful.fg,
        type = "dock"
    }

    controlpanel.screen = screen

    if beautiful.animation.style == "none" then
        controlpanel.visible = false
    end

    local controlpanel_bg =
        wibox.widget {
        helpers.empty_widget,
        opacity = beautiful.bg_opacity,
        widget = wibox.container.background
    }

    if beautiful.border.radius then
        local ba = beautiful.border.rounding
        controlpanel.shape =
            helpers.prrect(beautiful.border.radius, ba.tl, ba.tr, ba.br, ba.bl)
    end

    ----------------------------------------------------------------------------
    -- Setting up the Layout of the StartScreen

    local dpi = require("beautiful").dpi

    controlpanel.player = require("widgets.player")
    local boxes = {
        helpers.vpad(3),
        {
            require("widgets.weather"),
            require("widgets.datetime"),
            layout = wibox.layout.fixed.vertical
        },
        helpers.vpad(1),
        controlpanel.player,
        helpers.vpad(2),
        require("widgets.todo"),
        helpers.vpad(2),
        require("widgets.minicontrols"),
        layout = wibox.layout.fixed.vertical
    }

    boxes = helpers.centered(boxes, "horizontal")

    controlpanel:setup {
        {
            controlpanel_bg,
            {
                {
                    {
                        nil,
                        nil,
                        require("widgets.battery"),
                        expand = "none",
                        layout = wibox.layout.align.horizontal
                    },
                    layout = wibox.layout.fixed.vertical
                },
                top = dpi(10),
                left = dpi(10),
                right = dpi(15),
                widget = wibox.container.margin
            },
            boxes,
            layout = wibox.layout.stack
        },
        top = beautiful.border.top,
        right = beautiful.border.right,
        bottom = beautiful.border.bottom,
        left = beautiful.border.left,
        color = beautiful.border.color,
        widget = wibox.container.margin
    }

    ----------------------------------------------------------------------------
    -- Adding Toggle Controls with Animation to the Widget

    controlpanel.dx = get_x(screen)
    controlpanel.dy = get_y(screen)

    controlpanel.dw = get_width(screen)
    controlpanel.dh = get_height(screen)

    controlpanel.animator = nil
    controlpanel.visibility = false

    controlpanel.x = controlpanel.dx
    controlpanel.y = controlpanel.dy

    controlpanel.width = controlpanel.dw
    controlpanel.height = controlpanel.dh

    if beautiful.animation.style ~= "none" then
        if beautiful.animation.style == "opacity" then
            -- Non-zero to avoid glitches with full-screen windows
            controlpanel.opacity = 0.01
        else
            if beautiful.animation.style == "slide_tb" then
                controlpanel.y = screen.workarea.y
                controlpanel.height = 1
            elseif beautiful.animation.style == "slide_bt" then
                controlpanel.y = screen.workareag.y + screen.workarea.height
                controlpanel.height = 1
            elseif beautiful.animation.style == "slide_lr" then
                controlpanel.x = screen.workarea.x
                controlpanel.width = 1
            elseif beautiful.animation.style == "slide_rl" then
                controlpanel.x = screen.workarea.x + screen.workarea.width
                controlpanel.width = 1
            end
        end
    end

    function controlpanel:show()
        self.visibility = true

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
                    x = self.dx,
                    y = self.dy,
                    width = self.dw,
                    height = self.dh
                },
                beautiful.animation.easing
            )
            self.animator:startAnimation()
        end

        if self.player.visualizer then
            self.player.visualizer:start()
        end
    end

    function controlpanel:hide()
        self.visibility = false

        if beautiful.animation.style ~= "none" then
            local target = {}

            if beautiful.animation.style == "opacity" then
                -- Non-zero to avoid glitches with full-screen windows
                target.opacity = 0.01
            else
                target.x = self.dx
                target.y = self.dy

                if beautiful.animation.style == "slide_tb" then
                    target.y = self.screen.workarea.y
                    target.height = 1
                elseif beautiful.animation.style == "slide_bt" then
                    target.y = self.screen.workarea.y + self.screen.workarea.height
                    target.height = 1
                elseif beautiful.animation.style == "slide_lr" then
                    target.x = self.screen.workarea.x
                    target.width = 1
                elseif beautiful.animation.style == "slide_rl" then
                    target.x = self.screen.workarea.x + self.screen.workarea.width
                    target.width = 1
                end
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

        if self.player.visualizer then
            self.player.visualizer:stop()
        end
    end

    function controlpanel:toggle()
        if not self.visibility then
            self:show()
        else
            self:hide()
        end
    end

    ----------------------------------------------------------------------------
    return controlpanel
end

-- -------------------------------------------------------------------------------------
return create_controlpanel
