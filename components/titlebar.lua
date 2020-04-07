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
    -- Left button - move {{
    awful.button(
        {}, 1,
        function()
            local c = mouse.object_under_pointer()

            client.focus = c
            c:raise()

            awful.mouse.client.move(c)
        end
    ),
    -- }}

    -- Middle button - close {{
    awful.button(
        {}, 2,
        function ()
            window_to_kill = mouse.object_under_pointer()
            window_to_kill:kill()
        end
    ),
    -- }}

    -- Right button - resize {{
    awful.button(
        {}, 3,
        function()
            c = mouse.object_under_pointer()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end
    )
    -- }}
)

--------------------------------------------------------------------------------
-- Creating a Titlebar

local positions
if beautiful.imitate_borders then
    positions = {"top", "bottom", "left", "right"}
else
    positions = {beautiful.position}
end

if beautiful.enabled then
    client.connect_signal(
        "request::titlebars",
        function(c)
            for _, pos in ipairs(positions) do
                local size
                local title_text
                local item_layout = "horizontal"

                if pos == beautiful.position then
                    -- For main titlebar

                    -- Title text widget {{
                    if beautiful.title.enabled then
                        title_text = {
                            font   = beautiful.title.font,
                            align  = beautiful.title.align,
                            widget = awful.titlebar.widget.titlewidget(c),
                        }
                    end
                    -- }}

                    size = beautiful.size

                    -- Different layouts for positions {{
                    if pos == "left" or pos == "right" then
                        item_layout = "vertical"
                        center_layout = "horizontal"
                    end
                    -- }}
                else
                    -- For borders as titlebars
                    size = beautiful.border_size
                end

                -- Create titlebar {{
                local titlebar = awful.titlebar(
                    c,
                    {
                        font      = beautiful.font,
                        size      = size,
                        position  = pos,
                        bg_focus  = beautiful.bg_focus,
                        bg_normal = beautiful.bg_normal
                    }
                )
                -- }}

                local sticky, ontop

                -- Add icons for main titlebar {{
                if pos == beautiful.position then
                    titlebar.sticky = wibox.widget {
                        {
                            image         = beautiful.sticky_icon,
                            forced_height = beautiful.icon_size,
                            forced_width  = beautiful.icon_size,
                            widget        = wibox.widget.imagebox
                        },
                        visible = c.sticky,
                        margins   = beautiful.icon_spacing,
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
                        margins = beautiful.icon_spacing,
                        widget  = wibox.container.margin
                    }
                end
                -- }}

                -- Rotate titlebar contents for different positions {{
                local direction = "north"
                if pos == "right" then
                    direction = "west"
                elseif pos == "left" then
                    direction = "east"
                end
                -- }}

                -- Wrapper for title {{
                local title_widget = wibox.container {
                    {
                        {
                            title_text,
                            buttons = buttons,
                            layout  = wibox.layout.flex[item_layout]
                        },
                        left   = beautiful.margin,
                        right  = beautiful.margin,
                        widget = wibox.container.margin
                    },
                    direction = direction,
                    widget    = wibox.container.rotate
                }
                -- }}

                -- Setup titlebar {{
                titlebar:setup {
                    title_widget,
                    {
                        nil, nil,
                        helpers.center_align_widget(
                            {
                                titlebar.sticky,
                                titlebar.ontop,
                                layout  = wibox.layout.fixed[item_layout]
                            },
                            center_layout
                        ),
                        layout = wibox.layout.align[item_layout]
                    },
                    layout = wibox.layout.stack
                }
                -- }}

                if pos == beautiful.pos then
                    -- Set main titlebar as client titlebar
                    c.titlebar = titlebar
                end
            end
        end
    )
end

--------------------------------------------------------------------------------
-- Adding Connect Signals to Update Titlebar Indicators

if beautiful.enabled then
    -- Property handler for sticky {{
    client.connect_signal(
        "property::sticky",
        function(c)
            c.titlebar.sticky.visible = c.sticky
        end
    )
    -- }}

    -- Property handler for ontop {{
    client.connect_signal(
        "property::ontop",
        function(c)
            c.titlebar.ontop.visible = c.ontop
        end
    )
    -- }}
end

--------------------------------------------------------------------------------
return titlebars
