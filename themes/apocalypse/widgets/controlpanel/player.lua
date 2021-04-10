-- =====================================================================================
--   Name:       player.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/widgets ...
--               ... controlpanel/player.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based player widget
-- =====================================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful").controlpanel.player

-- -------------------------------------------------------------------------------------
-- Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating Information Textboxes and Imageboxes

local title_text =
    wibox.widget {
    text = "---------",
    font = beautiful.font.title,
    align = "center",
    valign = "center",
    forced_height = 22,
    widget = wibox.widget.textbox
}

local artist_text =
    wibox.widget {
    text = "---------",
    font = beautiful.font.artist,
    align = "center",
    valign = "center",
    forced_height = 22,
    widget = wibox.widget.textbox
}

-- -------------------------------------------------------------------------------------
-- Creating Visualizer

-- FIXME: significant delay between audio and visuals

local visualizer
if beautiful.visualizer.enabled then
    visualizer =
        wibox.widget {
        bars = {},
        spacing = beautiful.visualizer.spacing,
        layout = wibox.layout.flex.horizontal
    }

    for idx = 1, 16 do
        visualizer.bars[idx] =
            wibox.widget {
            helpers.empty_widget,
            bg = beautiful.visualizer.color,
            widget = wibox.container.background
        }

        visualizer:add(
            wibox.container {
                visualizer.bars[idx],
                valign = "top",
                halign = "center",
                content_fill_horizontal = true,
                content_fill_vertical = false,
                widget = wibox.container.place
            }
        )
    end

    local visualizer_subscribe_script =
        [[
        bash -c "
            cava -p ]] ..
        beautiful.visualizer.config .. [[
        "
    ]]
    local visualizer_kill_script =
        [[
        ps x \
            | grep "[c]ava -p" \
            | awk '{print $1}' \
            | xargs kill
    ]]

    visualizer.is_running = false

    function visualizer:stop()
        if self.is_running then
            self.is_running = true
            awful.spawn.easy_async_with_shell(
                visualizer_kill_script,
                function()
                    self.is_running = false
                end
            )
        end
    end

    function visualizer:start()
        if not self.is_running then
            self.is_running = false
            awful.spawn.easy_async_with_shell(
                visualizer_kill_script,
                function()
                    awful.spawn.with_line_callback(
                        visualizer_subscribe_script,
                        {
                            stdout = function(line)
                                local idx = 1
                                for val in string.gmatch(line, "[0-9]+") do
                                    self.bars[idx].forced_height =
                                        tonumber(val) / 1500 * beautiful.height

                                    idx = idx + 1
                                end
                            end
                        }
                    )
                    self.is_running = true
                end
            )
        end
    end
end

-- -------------------------------------------------------------------------------------
-- Creating Control Buttons

local prev_button =
    wibox.widget {
    image = beautiful.icons.prev,
    forced_height = beautiful.icons.size,
    widget = wibox.widget.imagebox
}

local toggle_button =
    wibox.widget {
    image = beautiful.icons.play,
    forced_height = beautiful.icons.size,
    widget = wibox.widget.imagebox
}

local next_button =
    wibox.widget {
    image = beautiful.icons.next,
    forced_height = beautiful.icons.size,
    widget = wibox.widget.imagebox
}

-- -------------------------------------------------------------------------------------
-- Creating the Widget

local player =
    helpers.boxed(
    {
        {
            visualizer,
            margins = beautiful.visualizer.spacing,
            widget = wibox.container.margin
        },
        {
            {
                {
                    title_text,
                    helpers.vpad(0.2),
                    artist_text,
                    layout = wibox.layout.align.vertical
                },
                helpers.vpad(2),
                helpers.centered(
                    {
                        prev_button,
                        toggle_button,
                        next_button,
                        spacing = beautiful.icons.margin,
                        layout = wibox.layout.flex.horizontal
                    },
                    "horizontal"
                ),
                helpers.vpad(2),
                require("widgets.controlpanel.volume"),
                layout = wibox.layout.fixed.vertical
            },
            top = beautiful.padding.topbottom,
            right = beautiful.padding.leftright,
            bottom = beautiful.padding.topbottom,
            left = beautiful.padding.leftright,
            widget = wibox.container.margin
        },
        layout = wibox.layout.stack
    },
    beautiful.width,
    beautiful.height,
    false,
    beautiful.bg,
    beautiful.border_radius
)

player.visualizer = visualizer

local album = ""
local title = "----------"
local artist = "----------"
local playback

local function update_widget(cmd, data)
    if cmd == "metadata" then
        album = gears.string.xml_escape(data.album or "") or ""
        title = gears.string.xml_escape(data.title or "") or ""
        artist = gears.string.xml_escape(data.artist or "") or ""
    elseif cmd == "playback" then
        playback = data:lower()

        if playback == "playing" then
            toggle_button.image = beautiful.icons.pause
        elseif playback == "stopped" then
            toggle_button.image = beautiful.icons.play

            album = ""
            title = ""
            artist = "----------"
        else
            toggle_button.image = beautiful.icons.play
        end
    else
        return
    end

    local tt
    if title == "" then
        tt = "----------"
    else
        tt = title
    end

    local at
    if artist == "" then
        if album == "" then
            at = "----------"
        else
            at = album
        end
    else
        if album == "" then
            at = artist
        else
            at = artist .. " -- " .. album
        end
    end

    artist_text.markup = helpers.colorize_text(at, beautiful.fg.artist[playback])
    title_text.markup = helpers.colorize_text(tt, beautiful.fg.title[playback])
end

-- Connect to daemon signal {{{
awesome.connect_signal("daemons::mpris", update_widget)

player.mpris_daemon = require("daemons.mpris")
gears.timer.delayed_call(
    function()
        player.mpris_daemon.emit()
        if not player.mpris_daemon.is_running then
            player.mpris_daemon.run()
        end
    end
)
-- }}}

-- -------------------------------------------------------------------------------------
-- Button Controls

prev_button:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            function()
                awesome.emit_signal("controls::mpris", "prev")
            end
        )
    )
)

toggle_button:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            function()
                awesome.emit_signal("controls::mpris", "toggle")
            end
        )
    )
)

next_button:buttons(
    gears.table.join(
        awful.button(
            {},
            1,
            function()
                awesome.emit_signal("controls::mpris", "next")
            end
        )
    )
)

-- -------------------------------------------------------------------------------------
return player
