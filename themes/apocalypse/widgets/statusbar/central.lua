-- =====================================================================================
--   Name:       central.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/widgets ...
--               ...  statusbar/central.lua
--   License:    The MIT License (MIT)
--
--   Central datetime, calendar and notifications manager
-- =====================================================================================

local wibox = require("wibox")
local beautiful = require("beautiful").statusbar.central

-- -------------------------------------------------------------------------------------
-- Creating the Widget

local datetime = require("widgets.statusbar.datetime")

local central =
    wibox.widget {
    require("widgets.statusbar.calendar"),
    layout = wibox.layout.flex.horizontal
}
require("widgets.elements.popup")(central, datetime, beautiful.popup)

-- -------------------------------------------------------------------------------------
return datetime
