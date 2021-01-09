-- =====================================================================================
--   Name:       brightness.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/config-awesom/themes/apocalypse/notifs ...
--               ... brightness.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based brightness notifications
-- =====================================================================================

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful").notifications.brightness

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")
local brightness_daemon = require("daemons.brightness")
local animation = require("modules.animation")

-- -------------------------------------------------------------------------------------
-- Helper Functions

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
-- Creating Volume Icons

local icon =
    wibox.widget {
    resize = true,
    image = beautiful.icon,
    forced_width = beautiful.icon_size,
    forced_height = beautiful.icon_size,
    opacity = beautiful.icon_opacity,
    widget = wibox.widget.imagebox
}

-- -------------------------------------------------------------------------------------
-- Creating the Volume Widget

local bar =
    wibox.widget {
    value = 0,
    maximum = 100,
    bar_shape = helpers.rrect(beautiful.bar.border_radius),
    bar_height = beautiful.bar.width,
    bar_color = beautiful.bar.background,
    handle_color = beautiful.bar.color,
    handle_shape = gears.shape.rect,
    handle_border_color = beautiful.bar_color,
    handle_width = 0,
    handle_border_width = 0,
    forced_width = beautiful.bar.height,
    forced_height = beautiful.bar.width,
    enabled = true,
    widget = wibox.widget.slider
}

local cover =
    wibox.widget {
    bg = beautiful.bar.color,
    shape = helpers.rrect(beautiful.bar.border_radius),
    forced_width = beautiful.bar.width,
    widget = wibox.container.background
}
cover:setup {
    nil,
    layout = wibox.layout.align.vertical
}

-- Creating the widget
local slider =
    wibox.widget {
    {
        helpers.centered(icon, "horizontal"),
        bottom = beautiful.spacing,
        layout = wibox.container.margin
    },
    {
        {
            bar,
            direction = "east",
            widget = wibox.container.rotate
        },
        {
            {
                nil,
                nil,
                cover,
                layout = wibox.layout.align.vertical
            },
            bg = beautiful.bar_bg,
            shape = helpers.rrect(beautiful.bar.border_radius),
            forced_width = beautiful.bar.width,
            widget = wibox.container.background
        },
        layout = wibox.layout.stack
    },
    layout = wibox.layout.align.vertical
}

-- Adding update signals {{{
--   In order to make this work, an extra *hack* line needs to be added in the
--   slider.lua file (/usr/share/awesome/lib/wibox/widget)
--   >> self:emit_signal("button::release", 42, 42, 1, {}, geo)
--   The above line must be added in the function "mouse_press". Diff ->
--       capi.mousegrabber.run(function(mouse)
--           if not mouse.buttons[1] then
--   +            self:emit_signal("button::release", 42, 42, 1, {}, geo)
--               return false
--           end
-- }}}
bar:connect_signal(
    "button::release",
    function(_, _, _, button, _, _)
        if button == 1 and bar.enabled == true then
            awesome.emit_signal("controls::brightness", "set", bar.value)
        end
    end
)

bar:connect_signal(
    "property::value",
    function()
        cover.forced_height = bar.value * beautiful.bar.scale
    end
)

-- -------------------------------------------------------------------------------------
-- Creating the Popup Widget

local wrapper = {
    slider,
    top = beautiful.margin.top,
    right = beautiful.margin.right,
    bottom = beautiful.margin.bottom,
    left = beautiful.margin.left,
    widget = wibox.container.margin
}
local brightness =
    awful.popup {
    widget = wrapper,
    shape = helpers.rrect(beautiful.border_radius),
    bg = beautiful.background,
    height = beautiful.height,
    width = beautiful.width,
    ontop = true,
    visible = false,
    opacity = 0
}

brightness.visibility = false
brightness.showing = false
brightness.hiding = false

brightness.show_animator = nil
brightness.hide_animator = nil

function brightness:hide()
    if brightness.visibility == false then
        if brightness.showing or brightness.hiding then
            return
        end
        brightness.hiding = true
        hide_animator =
            animation(
            self,
            beautiful.animation.hide.duration,
            {
                opacity = 0
            },
            beautiful.animation.hide.easing
        )
        hide_animator:startAnimation()

        hide_animator:connect_signal(
            "anim::animation_finished",
            function()
                self.visible = false
                brightness.hiding = false
            end
        )
    end
end
local hideout_timer =
    gears.timer {
    timeout = 2,
    autostart = false,
    callback = function()
        brightness:hide()
    end,
    single_shot = true
}

function brightness:force_hide()
    if self.hiding and self.hide_animator then
        self.hide_animator:stopAnimation()
        self.hiding = false
    end

    if self.showing and self.show_animator then
        self.show_animator:stopAnimation()
        self.showing = false
    end

    self.opacity = 0
    self.visible = false
end

function brightness:show()
    local screen = helpers.get_screen()

    for _, notif in pairs(screen.notifs) do
        if notif.visible and notif ~= self then
            notif:force_hide()
        end
    end

    self.visible = true

    if self.opacity ~= 1 then
        hideout_timer:stop()

        if brightness.showing then
            return
        end
        if brightness.hiding then
            brightness.hiding = false
            hide_animator:stopAnimation()
        end
        brightness.showing = true

        self.x = get_x(screen)
        self.y = get_y(screen)

        show_animator =
            animation(
            self,
            beautiful.animation.show.duration,
            {
                opacity = 1
            },
            beautiful.animation.show.easing
        )
        show_animator:startAnimation()

        show_animator:connect_signal(
            "anim::animation_finished",
            function()
                hideout_timer:start()
                brightness.showing = false
            end
        )
    else
        hideout_timer:again()
    end
end

brightness:connect_signal(
    "mouse::enter",
    function()
        brightness.visibility = true
        brightness:show()
    end
)
brightness:connect_signal(
    "mouse::leave",
    function()
        brightness.visibility = false
        hideout_timer:again()
    end
)

local function update_widget(cmd, b)
    if cmd ~= "changed" then
        return
    end

    brightness:show()

    bar.value = b
end

-- Connect to daemon signal {{{
awesome.connect_signal("daemons::brightness", update_widget)

gears.timer.delayed_call(
    function()
        brightness_daemon.emit()
        if not brightness_daemon.is_running then
            brightness_daemon.run()
        end
    end
)
-- }}}

-- -------------------------------------------------------------------------------------
-- Button Controls

brightness:buttons(
    gears.table.join(
        awful.button(
            {},
            4,
            function()
                awesome.emit_signal("controls::brightness", "increase")
            end
        ),
        awful.button(
            {},
            5,
            function()
                awesome.emit_signal("controls::brightness", "decrease")
            end
        )
    )
)

return brightness
