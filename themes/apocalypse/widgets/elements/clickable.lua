-- =====================================================================================
--   Name:       clickable.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/themes/apocalypse/widgets/elements ...
--               ... clickable.lua
--   License:    The MIT License (MIT)
--
--   Element clickable for apocalypse theme widgets
-- =====================================================================================

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the Clickable Element Wrapper

local function clickable(widget, default_bg, hover_bg)
    helpers.add_clickable_effect(
        widget,
        function()
            widget.bg = hover_bg
        end,
        function()
            widget.bg = default_bg
        end
    )

    return widget
end

-- -------------------------------------------------------------------------------------
return clickable
