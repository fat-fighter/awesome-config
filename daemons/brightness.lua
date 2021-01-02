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

local daemon = {is_running = false, temp = 4500, brightness = 1.0}
awful.spawn("redshift -P -O " .. daemon.temp .. " -b " .. daemon.brightness)

function daemon.emit()
    awesome.emit_signal(
        "daemons::brightness",
        "changed",
        daemon.brightness,
        daemon.temp
    )
end

local function run_brightness_daemon()
    daemon.is_running = true
end
daemon.run = run_brightness_daemon

-- -------------------------------------------------------------------------------------
-- Connect Handlers

awesome.connect_signal(
    "controls::brightness",
    function(command, brightness)
        if command == "set" then
            brightness = brightness
        elseif command == "increase" then
            brightness = daemon.brightness + 0.05
        elseif command == "decrease" then
            brightness = daemon.brightness - 0.05
        else
            error("Error: daemon brightness, command '" .. command .. "' not found")
        end

        brightness = math.max(math.min(brightness, 1), 0)
        daemon.brightness = brightness

        awful.spawn("redshift -P -O " .. daemon.temp .. " -b " .. brightness)
        daemon.emit()
    end
)
awesome.connect_signal(
    "controls::temperature",
    function(command, temp)
        if command == "set" then
            daemon.temp = temp
        elseif command == "increase" then
            daemon.temp = daemon.temp + 100
        elseif command == "decrease" then
            daemon.temp = daemon.temp - 100
        else
            error("Error: daemon temperature, command '" .. command .. "' not found")
        end

        awful.spawn("redshift -P -O " .. daemon.temp .. " -b " .. daemon.brightness)
        daemon.emit()
    end
)

-- -------------------------------------------------------------------------------------
return daemon
