-- =====================================================================================
--   Name:       datetime.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/widgets ...
--               ... datetime.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based datetime widget
-- =====================================================================================

local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local vicious = require("modules.vicious")
local beautiful = require("beautiful").controlpanel.datetime

-- -------------------------------------------------------------------------------------
-- Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Defining Local Variables

local timezones = {
    {
        location = "New York, NY",
        offset = 0
    },
    {
        location = "Kanpur, UP",
        offset = 37800
    }
}

local active_timezone = 1

-- -------------------------------------------------------------------------------------
-- Creating the Widget

local time_blocks = {}
local colorize = helpers.colorize_text

for i = 1, #timezones do
    local time =
        wibox.widget {
        font = beautiful.time.font,
        align = "right",
        forced_width = beautiful.time.width,
        forced_height = beautiful.time.height,
        widget = wibox.widget.textbox
    }

    local date =
        wibox.widget {
        font = beautiful.date.font,
        align = "right",
        forced_width = beautiful.date.width,
        forced_height = beautiful.date.height,
        widget = wibox.widget.textbox
    }

    local location =
        wibox.widget {
        font = beautiful.location.font,
        align = "right",
        forced_width = beautiful.location.width,
        forced_height = beautiful.location.height,
        widget = wibox.widget.textbox
    }

    vicious.register(
        time,
        vicious.widgets.date,
        colorize("%H:%M", beautiful.time.fg),
        2,
        timezones[i].offset
    )
    vicious.register(
        date,
        vicious.widgets.date,
        colorize("%A %b %d", beautiful.date.fg),
        2,
        timezones[i].offset
    )

    location.markup = colorize(timezones[i].location, beautiful.location.fg)

    time_blocks[i] =
        wibox.widget {
        helpers.centered(
            {
                location,
                helpers.vpad(0.3),
                date,
                layout = wibox.layout.fixed.vertical
            },
            "vertical"
        ),
        time,
        visible = false,
        layout = wibox.layout.fixed.horizontal
    }

    if i == active_timezone then
        time_blocks[i].visible = true
    end
end

time_blocks.layout = wibox.layout.fixed.vertical

local datetime =
    wibox.widget {
    {
        {
            time_blocks[1],
            time_blocks[2],
            layout = wibox.layout.fixed.horizontal
        },
        halign = "right",
        valign = "center",
        forced_height = beautiful.time.height,
        widget = wibox.container.place
    },
    top = beautiful.margin.top,
    right = beautiful.margin.right,
    bottom = beautiful.margin.bottom,
    left = beautiful.margin.left,
    widget = wibox.container.margin
}

-- -------------------------------------------------------------------------------------
-- Button Controls

datetime:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            function()
                time_blocks[active_timezone].visible = false

                active_timezone = active_timezone + 1
                if active_timezone > #time_blocks then
                    active_timezone = 1
                end

                time_blocks[active_timezone].visible = true
            end
        )
    )
)

-- -------------------------------------------------------------------------------------
return datetime
