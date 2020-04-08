-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local wibox = require("wibox")
local beautiful = require("beautiful").startscreen.controls

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the Widget

local centered = helpers.center_align_widget

return {
    {
        {
            {
                {
                    require("widgets.volume"),
                    nil,
                    require("widgets.brightness"),
                    expand = "none",
                    layout = wibox.layout.align.horizontal,
                },
                nil,
                {
                    require("widgets.screenshot"),
                    top = beautiful.margin * 2,
                    widget = wibox.container.margin
                },
                expand = "none",
                layout = wibox.layout.align.vertical
            },
            forced_width = (beautiful.widget_width + beautiful.margin) * 2,
            widget = wibox.container.constraint
        },
        nil,
        {
            {
                {
                    {
                        {
                            require("widgets.wifi"),
                            nil,
                            require("widgets.bluetooth"),
                            expand = none,
                            layout = wibox.layout.align.horizontal
                        },
                        left = beautiful.inner_margin or 0,
                        right = beautiful.inner_margin or 0,
                        widget = wibox.container.margin
                    },
                    bg = beautiful.bg,
                    shape = helpers.rrect(beautiful.border_radius or 0),
                    forced_width = (beautiful.widget_width + beautiful.margin) * 2,
                    forced_height = beautiful.widget_height,
                    widget = wibox.container.background
                },
                nil,
                require("widgets.weather"),
                expand = "none",
                layout = wibox.layout.align.vertical
            },
            forced_width = (beautiful.widget_width + beautiful.margin) * 2,
            widget = wibox.container.constraint
        },
        layout = wibox.layout.align.horizontal
    },
    margins = beautiful.margin or 0,
    widget = wibox.container.margin
}
