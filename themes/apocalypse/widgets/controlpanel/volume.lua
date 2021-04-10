-- =====================================================================================
--   Name:       volume.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/config-awesom/themes/apocalypse/widgets ...
--               ... controlpanel/volume.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based volume widget
-- =====================================================================================

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful").controlpanel.volume

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")
local volume_daemon = require("daemons.volume")

-- -------------------------------------------------------------------------------------
-- Defining Local Variables

local muted

-- -------------------------------------------------------------------------------------
-- Creating Volume Slider

local bar =
    wibox.widget {
    bar_shape = helpers.rrect(beautiful.bar.radius),
    bar_height = beautiful.bar.size,
    bar_color = beautiful.bar.color,
    handle_color = beautiful.handle.color,
    handle_shape = gears.shape.circle,
    handle_width = beautiful.handle.size,
    handle_border_width = 0,
    forced_width = beautiful.width,
    forced_height = beautiful.height,
    enabled = true,
    widget = wibox.widget.slider
}

local cover =
    wibox.widget {
    helpers.empty_widget,
    bg = beautiful.cover.color,
    shape = helpers.rrect(beautiful.bar.radius),
    forced_height = beautiful.cover.size,
    widget = wibox.container.background
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
            awesome.emit_signal("controls::volume", "set", bar.value)
        end
    end
)

bar:connect_signal(
    "property::value",
    function()
        cover.forced_width = bar.value * beautiful.scale
    end
)

-- -------------------------------------------------------------------------------------
-- Creating Volume Icons

local low_icon =
    wibox.widget {
    image = beautiful.low_icon,
    resize = true,
    opacity = beautiful.icon_opacity,
    forced_width = beautiful.icon_size,
    forced_height = beautiful.icon_size,
    widget = wibox.widget.imagebox
}
local high_icon =
    wibox.widget {
    image = beautiful.high_icon,
    resize = true,
    opacity = beautiful.icon_opacity,
    forced_width = beautiful.icon_size,
    forced_height = beautiful.icon_size,
    widget = wibox.widget.imagebox
}

-- -------------------------------------------------------------------------------------
-- Creating the Volume Widget

local volume =
    helpers.centered(wibox.widget {
    helpers.centered(low_icon, "vertical"),
    helpers.hpad(2),
    {
        bar,
        {
            helpers.centered(cover, "vertical"),
            nil,
            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.stack
    },
    helpers.hpad(2),
    helpers.centered(high_icon, "vertical"),
    layout = wibox.layout.fixed.horizontal
})

local function update_widget(cmd, vol, mute)
    if cmd ~= "changed" or vol == nil then
        return
    end

    muted = mute

    if mute then
        bar.enabled = false

        cover.bg = beautiful.bar.color
        bar.handle_color = beautiful.bar_color
    else
        bar.enabled = true

        cover.bg = beautiful.cover.color
        bar.handle_color = beautiful.handle.color
    end

    bar.value = math.min(vol, 100)
end

-- Connect to daemon signal {{{
awesome.connect_signal("daemons::volume", update_widget)

gears.timer.delayed_call(
    function()
        if not volume_daemon.is_running then
            volume_daemon.run()
        end
    end
)
-- }}}

-- -------------------------------------------------------------------------------------
-- Button Controls

volume:buttons(
    gears.table.join(
        awful.button(
            {},
            3,
            function()
                awesome.emit_signal("controls::volume", "mute")

                if muted then
                    bar.enabled = false

                    cover.bg = beautiful.bar.color
                    bar.handle_color = beautiful.bar_color
                else
                    bar.enabled = true

                    cover.bg = beautiful.cover.color
                    bar.handle_color = beautiful.handle.color
                end

                muted = not muted
            end
        ),
        awful.button(
            {},
            4,
            function()
                awesome.emit_signal("controls::volume", "increase")
            end
        ),
        awful.button(
            {},
            5,
            function()
                awesome.emit_signal("controls::volume", "decrease")
            end
        )
    )
)

low_icon:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            function()
                awesome.emit_signal("controls::volume", "set", 0)
            end
        )
    )
)

high_icon:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            function()
                awesome.emit_signal("controls::volume", "set", 100)
            end
        )
    )
)

return volume
