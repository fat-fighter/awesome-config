-- =====================================================================================
--   Name:       todo.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/widgets ...
--               ... todo.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based todo/todo widget
-- =====================================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful").controlpanel.todo

-- -------------------------------------------------------------------------------------
-- Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the Widget

local title =
    wibox.widget {
    font = beautiful.title.font,
    align = "left",
    valign = "center",
    markup = helpers.colorize_text("TODO", beautiful.title.fg),
    widget = wibox.widget.textbox
}

local text =
    wibox.widget {
    widget = wibox.container.background
}

local edit =
    wibox.widget {
    image = beautiful.edit_icon,
    forced_width = beautiful.edit_icon_size,
    forced_height = beautiful.edit_icon_size,
    widget = wibox.widget.imagebox
}

local todo =
    helpers.boxed(
    wibox.widget {
        {
            {
                {
                    title,
                    nil,
                    edit,
                    layout = wibox.layout.align.horizontal
                },
                {
                    helpers.vpad(0.2),
                    color = beautiful.title.fg .. "99",
                    bottom = 1,
                    widget = wibox.container.margin
                },
                helpers.vpad(0.4),
                text,
                layout = wibox.layout.fixed.vertical
            },
            margins = beautiful.margin,
            widget = wibox.container.margin
        },
        top = beautiful.padding.topbottom,
        right = beautiful.padding.leftright,
        bottom = beautiful.padding.topbottom,
        left = beautiful.padding.leftright,
        widget = wibox.container.margin
    },
    beautiful.width,
    beautiful.height,
    true,
    beautiful.bg,
    beautiful.border_radius
)

-- -------------------------------------------------------------------------------------
-- Update Function

local function get_markup(line)
    if line:sub(1, 1) == "#" then
        return helpers.colorize_text(line:sub(2, -1), beautiful.text.heading_fg)
    end

    return helpers.colorize_text(line, beautiful.text.fg)
end

local function update_widget()
    awful.spawn.easy_async_with_shell(
        "cat ~/todo",
        function(stdout)
            local textboxes = {}
            for line in stdout:gmatch("[^\r\n]+") do
                table.insert(
                    textboxes,
                    wibox.widget {
                        markup = get_markup(line),
                        font = beautiful.text.font,
                        forced_height = beautiful.text.line_height,
                        widget = wibox.widget.textbox
                    }
                )
            end
            textboxes.layout = wibox.layout.fixed.vertical
            text:setup(textboxes)
        end
    )
end

local subscribe_script =
    [[
    bash -c "
        while (inotifywait ~/todo -qq) do
            echo ""
            sleep 1s  # this is needed because some editors move the file
        done
    "
]]

-- Kill old process and run daemon
awful.spawn.easy_async_with_shell(
    [[
        ps x \
            | grep "[i]notifywait -e modify /sys/class/backlight" \
            | awk '{print $1}' \
            | xargs kill
    ]],
    function()
        update_widget()
        awful.spawn.with_line_callback(subscribe_script, {stdout = update_widget})
    end
)

-- -------------------------------------------------------------------------------------
-- Button Controls

gears.table.join(
    edit:buttons(
        -- Left click - Open google mail
        awful.button(
            {},
            1,
            function()
                awful.spawn.with_shell(editor .. " ~/todo")
            end
        )
    )
)

-- -------------------------------------------------------------------------------------
return todo
