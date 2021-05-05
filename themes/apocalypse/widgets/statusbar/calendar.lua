-- =====================================================================================
--   Name:       calendar.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/widgets ...
--               ... statusbar/calendar.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based calendar widget
-- =====================================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful").statusbar.calendar

-- -------------------------------------------------------------------------------------
-- Creating Control Buttons for the Widget

local left_powerline = function(cr, _, _)
    return gears.shape.powerline(
        cr,
        beautiful.buttons_size,
        beautiful.buttons_size,
        -beautiful.buttons_depth
    )
end
local right_powerline = function(cr, _, _)
    return gears.shape.powerline(
        cr,
        beautiful.buttons_size,
        beautiful.buttons_size,
        beautiful.buttons_depth
    )
end

local prev_button =
    wibox.widget {
    bg = beautiful.fg.header,
    shape = left_powerline,
    forced_width = beautiful.buttons_size,
    forced_height = beautiful.buttons_size,
    widget = wibox.container.background
}
prev_button:setup {
    nil,
    layout = wibox.layout.fixed.vertical
}

local next_button =
    wibox.widget {
    bg = beautiful.fg.header,
    shape = right_powerline,
    forced_width = beautiful.buttons_size,
    forced_height = beautiful.buttons_size,
    widget = wibox.container.background
}
next_button:setup {
    nil,
    layout = wibox.layout.fixed.vertical
}

-- -------------------------------------------------------------------------------------
-- Creating Styles for Different Cell Types

local function decorate_cell(widget, flag)
    if widget.get_text and widget.set_markup and flag ~= "header" then
        local markup = widget:get_text():gsub("%s+", "")
        widget:set_markup(markup)
    end

    widget.font = beautiful.font[flag] or beautiful.font.default

    widget.align = "center"
    widget.valign = "center"

    if flag == "header" then
        widget =
            wibox.widget {
            prev_button,
            widget,
            next_button,
            layout = wibox.layout.align.horizontal
        }
    elseif flag == "focus" then
        widget = require("widgets.elements.highlight")(widget, beautiful.focus_highlight)
    end

    local padding = beautiful.padding[flag] or beautiful.padding.default

    return wibox.widget {
        {
            {
                widget,
                margins = padding,
                widget = wibox.container.margin
            },
            fg = beautiful.fg[flag] or beautiful.fg.default,
            bg = beautiful.bg[flag] or beautiful.bg.default,
            widget = wibox.container.background
        },
        top = (beautiful.margins[flag] or {}).top,
        right = (beautiful.margins[flag] or {}).right,
        bottom = (beautiful.margins[flag] or {}).bottom,
        left = (beautiful.margins[flag] or {}).left,
        color = (beautiful.margins[flag] or {}).color,
        widget = wibox.container.margin
    }
end

-- -------------------------------------------------------------------------------------
-- Creating the Calendar Widget

local calendar =
    wibox.widget {
    date = os.date("*t"),
    font = beautiful.font.weekday,
    spacing = beautiful.spacing,
    fn_embed = decorate_cell,
    long_weekdays = false,
    widget = wibox.widget.calendar.month
}

-- -------------------------------------------------------------------------------------
-- Adding Button Controls to the Calendar Widget

calendar:buttons(
    gears.table.join(
        -- Right Click - Reset date to current date
        awful.button(
            {},
            3,
            function()
                calendar.date = os.date("*t")
            end
        ),
        -- Scroll - Move to previous or next month
        awful.button(
            {},
            4,
            function()
                local month = calendar.date.month - 1
                local today = os.date("*t")
                if month == today.month then
                    calendar.date = today
                else
                    calendar.date = {month = month, year = calendar.date.year}
                end
            end
        ),
        awful.button(
            {},
            5,
            function()
                local month = calendar.date.month + 1
                local today = os.date("*t")
                if month == today.month then
                    calendar.date = today
                else
                    calendar.date = {month = month, year = calendar.date.year}
                end
            end
        )
    )
)

prev_button:buttons(
    gears.table.join(
        -- Left Click - Move to previous month
        awful.button(
            {},
            1,
            function()
                local month = calendar.date.month - 1
                local today = os.date("*t")
                if month == today.month then
                    calendar.date = today
                else
                    calendar.date = {month = month, year = calendar.date.year}
                end
            end
        )
    )
)

next_button:buttons(
    gears.table.join(
        -- Left Click - Move to next month
        awful.button(
            {},
            1,
            function()
                local month = calendar.date.month + 1
                local today = os.date("*t")
                if month == today.month then
                    calendar.date = today
                else
                    calendar.date = {month = month, year = calendar.date.year}
                end
            end
        )
    )
)

-- -------------------------------------------------------------------------------------
return calendar
