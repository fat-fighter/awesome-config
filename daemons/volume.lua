-- =====================================================================================
--   Name:       volume.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/daemons/volume.lua
--   License:    The MIT License (MIT)
--
--   Daemon for volume control
--
--   Note: This daemon requires pactl to be installed
-- =====================================================================================

local awful = require("awful")

-- -------------------------------------------------------------------------------------
-- Defining the Daemon

local daemon = {is_running = false}

local subscribe_script =
    [[
	bash -c "
		pactl subscribe 2> /dev/null | grep --line-buffered 'sink #'
	"
]]

function daemon.emit()
    awful.spawn.easy_async_with_shell(
        scripts_dir .. "volume get",
        function(line)
            local mute = line:match("^[NHML]") == "N"
            local volume = tonumber(line:match("(%d+)"))

            if volume ~= daemon.volume or mute ~= daemon.mute then
                awesome.emit_signal("daemons::volume", "changed", volume, mute)
            end
            daemon.volume = volume
            daemon.mute = mute
        end
    )
end

local function run_volume_daemon()
    daemon.is_running = true

    awful.spawn.with_line_callback(subscribe_script, {stdout = daemon.emit})
end

-- Kill old process and run daemon
function daemon.run()
    awful.spawn.easy_async_with_shell(
        [[
            ps x \
                | grep "[p]actl subscribe 2> /dev/null" \
                | awk '{print $1}' \
                | xargs kill
        ]],
        run_volume_daemon
    )
end

-- -------------------------------------------------------------------------------------
-- Connect Handlers

local volume_script = scripts_dir .. "volume"

awesome.connect_signal(
    "controls::volume",
    function(command, volume)
        local script

        if command == "set" then
            script = volume_script .. " set " .. tostring(volume)
        elseif command == "increase" then
            script = volume_script .. " set +2"
        elseif command == "decrease" then
            script = volume_script .. " set -2"
        elseif command == "mute" then
            script = volume_script .. " mute"
        else
            error("Error: daemon volume, command '" .. command .. "' not found")
        end

        awful.spawn.with_shell(script)
    end
)

-- -------------------------------------------------------------------------------------
return daemon
