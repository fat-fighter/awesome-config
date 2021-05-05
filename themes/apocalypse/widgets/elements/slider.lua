-- =====================================================================================
--   Name:       slider.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/themes/apocalypse/widgets/elements ...
--               ... slider.lua
--   License:    The MIT License (MIT)
--
--   Element slider for apocalypse theme widgets
-- =====================================================================================

local wibox = require("wibox")
local gears = require("gears")

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the Slider Element

function slider(value_update_fun, config)
    local bar =
        wibox.widget {
        bar_shape = helpers.rrect(config.bar.radius),
        bar_height = config.bar.size,
        bar_color = config.bar.color,
        handle_color = config.handle.color,
        handle_shape = gears.shape.circle,
        handle_width = config.handle.size,
        handle_border_width = 0,
        forced_height = config.height,
        forced_width = config.width,
        widget = wibox.widget.slider
    }

    local cover =
        wibox.widget {
        helpers.empty_widget,
        bg = config.cover.color,
        shape = helpers.rrect(config.bar.radius),
        forced_height = config.cover.size,
        widget = wibox.container.background
    }

    -- Adding update signals {{{
    --   In order to make this work, an extra *hack* line needs to be added in the
    --   slider.lua file (/usr/share/awesome/lib/wibox/widget)
    --   >> self:emit_signal("button::release", 42, 42, 1, {}, geo)
    --   The above line must be added in the function "mouse_press". Diff ->
    --       capi.mousegrabber.run(function(mouse)
    --           if not mouse.buttons[1] then
    --   +            self:emit_signal("button::release", 42, 42, 1, {}, geo)
    --               return false
    --           end
    -- }}}
    bar:connect_signal(
        "button::release",
        function(_, _, _, button, _, _)
            if button == 1 then
                value_update_fun(bar.value)
            end
        end
    )

    bar:connect_signal(
        "property::value",
        function()
            cover.forced_width =
                bar.value / config.scale * (config.width - config.handle.size)
        end
    )

    function bar:update(val)
        self.value = math.min(val, 100)
    end

    return {
        widget = wibox.widget {
            bar,
            {
                cover,
                halign = "left",
                valign = "center",
                height = config.height,
                widget = wibox.container.place
            },
            layout = wibox.layout.stack
        },
        cover = cover,
        bar = bar
    }
end

return slider
