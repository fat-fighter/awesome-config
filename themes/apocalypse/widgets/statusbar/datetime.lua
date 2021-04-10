-- =====================================================================================
--   Name:       datetime.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/widgets ...
--               ... statusbar/datetime.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based datetime widget
-- =====================================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local vicious = require("modules.vicious")
local beautiful = require("beautiful").statusbar.datetime

-- -------------------------------------------------------------------------------------
-- Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Defining Helper Functions

local function get_width(screen)
    local width = beautiful.calendar.width

    if type(width) == "function" then
        width = width(screen)
    end

    screen = screen or awful.screen.focused()
    width = width or screen.workarea.width

    return width
end

local function get_height(screen)
    local height = beautiful.calendar.height

    if type(height) == "function" then
        height = height(screen)
    end

    screen = screen or awful.screen.focused()
    height = height or screen.workarea.height

    return height
end

local function get_x(screen, width)
    local x = beautiful.calendar.x

    screen = screen or awful.screen.focused()

    if type(x) == "function" then
        x = x(screen)
    else
        x = x or (screen.workarea.width - width) / 2
    end

    return screen.workarea.x + x
end

local function get_y(screen, height)
    local y = beautiful.calendar.y

    screen = screen or awful.screen.focused()

    if type(y) == "function" then
        y = y(screen)
    else
        y = y or (screen.workarea.height - height) / 2
    end

    return screen.workarea.y + y
end

-- -------------------------------------------------------------------------------------
-- Creating the Widget

function create_datetime(screen)
    local colorize = helpers.colorize_text

    local text =
        wibox.widget {
        font = beautiful.font,
        widget = wibox.widget.textbox
    }

    vicious.register(
        text,
        vicious.widgets.date,
        colorize("%A  %b  %d     %r", beautiful.fg),
        1,
        0
    )

    local datetime =
        wibox.widget {
        text,
        halign = "center",
        valign = "center",
        forced_height = beautiful.height,
        widget = wibox.container.place
    }

    local calendar =
        wibox {
        visible = false,
        ontop = true,
        dock = false,
        bg = beautiful.calendar.bg,
        shape = helpers.rrect(beautiful.calendar.border_radius)
    }

    calendar.width = get_width(screen)
    calendar.height = get_height(screen)

    calendar.x = get_x(screen, calendar.width)
    calendar.y = get_y(screen, calendar.width)

    calendar:setup {
        require("widgets.statusbar.calendar"),
        layout = wibox.layout.flex.horizontal
    }

    datetime:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    calendar.visible = not calendar.visible
                end
            )
        )
    )

    return datetime
end

-- -------------------------------------------------------------------------------------
-- Button Controls

-- -------------------------------------------------------------------------------------
return create_datetime
