-- =====================================================================================
--   Name:       highlight.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/themes/apocalypse/widgets/elements ...
--               ... highlight.lua
--   License:    The MIT License (MIT)
--
--   Element highlight for apocalypse theme widgets
-- =====================================================================================

local wibox = require("wibox")
local gears = require("gears")

-- -------------------------------------------------------------------------------------
-- Creating the Highlight Element Wrapper

local function highlight(widget, bg, shape, border_width, border_color)
    if not shape then
        shape = gears.shape.circle
    end

    return wibox.widget {
        widget,
        bg = bg,
        shape = shape,
        shape_border_width = border_width,
        shape_border_color = border_color,
        widget = wibox.container.background
    }
end

-- -------------------------------------------------------------------------------------
return highlight
