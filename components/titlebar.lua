--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful").titlebar

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers   = require("helpers")

--------------------------------------------------------------------------------
-- Adding Button Controls

local buttons = gears.table.join(
    -- Left button - move
    awful.button(
        {}, 1,
        function()
            local c = mouse.object_under_pointer()

            client.focus = c
            c:raise()

            awful.mouse.client.move(c)
        end
    ),

    -- Middle button - close
    awful.button(
        {}, 2,
        function ()
            window_to_kill = mouse.object_under_pointer()
            window_to_kill:kill()
        end
    ),

    -- Right button - resize
    awful.button(
        {}, 3,
        function()
            c = mouse.object_under_pointer()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end
    )
)

--------------------------------------------------------------------------------
-- Creating a Titlebar

client.connect_signal(
    "request::titlebars",
    function(c)
        local title_widget

        if beautiful.title.enabled then
            title_widget       = awful.titlebar.widget.titlewidget(c)
            title_widget.font  = beautiful.title.font
            title_widget.align = beautiful.title.align
        else
            title_widget = wibox.widget.textbox("")
        end

        local titlebar = awful.titlebar(
            c,
            {
                font      = beautiful.font,
                size      = beautiful.size,
                position  = beautiful.position,
				bg_focus  = beautiful.bg_focus,
				bg_normal = beautiful.bg_normal
            }
        )

        local item_layout = "horizontal"
        if position == "left" or position == "right" then
            item_layout = "vertical"
        end

        titlebar.sticky = wibox.widget {
            {
                image         = beautiful.sticky_icon,
                forced_height = beautiful.icon_size,
                forced_width  = beautiful.icon_size,
                widget        = wibox.widget.imagebox
            },
            visible = c.sticky,
            right   = beautiful.icon_spacing,
            widget  = wibox.container.margin
        }
        titlebar.ontop = wibox.widget {
            {
                image         = beautiful.ontop_icon,
                forced_height = beautiful.icon_size,
                forced_width  = beautiful.icon_size,
                widget        = wibox.widget.imagebox
            },
            visible = c.ontop,
            right   = beautiful.icon_spacing,
            widget  = wibox.container.margin
        }

        titlebar:setup {
            {
                {
                    title_widget,
                    buttons = buttons,
                    layout  = wibox.layout.flex.horizontal
                },
                left   = beautiful.padding,
                right  = beautiful.padding,
                widget = wibox.container.margin
            },
            {
                nil, nil,
                helpers.center_align_widget(
                    {
                        titlebar.sticky,
                        titlebar.ontop,
                        layout  = wibox.layout.fixed[item_layout]
                    },
                    "vertical"
                ),
                layout = wibox.layout.align[item_layout]
            },
            layout = wibox.layout.stack
        }

        c.titlebar = titlebar
    end
)

--------------------------------------------------------------------------------
-- Adding Connect Signals to Update Titlebar Indicators

client.connect_signal(
    "property::sticky",
    function(c)
        c.titlebar.sticky.visible = c.sticky
    end
)
client.connect_signal(
    "property::ontop",
    function(c)
        c.titlebar.ontop.visible = c.ontop
    end
)

-- Disable popup tooltip on titlebar button hover
awful.titlebar.enable_tooltip = beautiful.tooltip

--------------------------------------------------------------------------------
return titlebars
