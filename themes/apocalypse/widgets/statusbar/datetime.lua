-- =====================================================================================
--   Name:       datetime.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/widgets ...
--               ... statusbar/datetime.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based datetime widget
-- =====================================================================================

local wibox = require("wibox")
local beautiful = require("beautiful").statusbar.datetime

-- -------------------------------------------------------------------------------------
-- Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the DateTime Widget

local colorize = helpers.colorize_text

local text =
    wibox.widget {
    font = beautiful.font,
    format = colorize("%A  %b  %d       %I:%M %p", beautiful.fg),
    widget = wibox.widget.textclock
}

local datetime =
    wibox.widget {
    text,
    halign = "center",
    valign = "center",
    widget = wibox.container.place
}

-- -------------------------------------------------------------------------------------
return datetime
