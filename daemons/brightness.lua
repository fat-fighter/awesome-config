-- =====================================================================================
--   Name:       brightness.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/daemons/brightness.lua
--   License:    The MIT License (MIT)
--
--   Daemon for brightness control
--
--   Note: This daemon requires light, inotifywait to be installed
-- =====================================================================================

local awful = require("awful")

-- -------------------------------------------------------------------------------------
-- Defining the Daemon

local daemon = {is_running = false}

local subscribe_script =
    [[
	bash -c "
	    while (inotifywait -e modify /sys/class/backlight/*/brightness -qq) do
            echo "";
        done
	"
]]

function daemon.emit()
    awful.spawn.easy_async_with_shell(
        "light -G",
        function(brightness)
            brightness = tonumber(brightness)

            awesome.emit_signal("daemons::brightness", "changed", brightness)
        end
    )
end

local function run_brightness_daemon()
    daemon.is_running = true

    awful.spawn.with_line_callback(subscribe_script, {stdout = daemon.emit})
end

-- Kill old process and run daemon
function daemon.run()
    awful.spawn.easy_async_with_shell(
        [[
            ps x \
                | grep "[i]notifywait -e modify /sys/class/backlight" \
                | awk '{print $1}' \
                | xargs kill
        ]],
        run_brightness_daemon
    )
end

-- -------------------------------------------------------------------------------------
-- Connect Handlers

awesome.connect_signal(
    "controls::brightness",
    function(command, brightness)
        if command == "set" then
            script = "light -S " .. tostring(brightness)
        elseif command == "increase" then
            script = "light -A 3"
        elseif command == "decrease" then
            script = "light -U 3"
        elseif command == "off" then
            script = "xset dpms force off"
        else
            error("Error: daemon brightness, command '" .. command .. "' not found")
        end

        awful.spawn.with_shell(script)
    end
)

-- -------------------------------------------------------------------------------------
return daemon
