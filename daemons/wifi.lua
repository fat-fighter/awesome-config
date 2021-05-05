-- =====================================================================================
--   Name:       wifi.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/daemons/wifi.lua
--   License:    The MIT License (MIT)
--
--   Daemon for wifi control using connman and the DBUS api exposed by connman
--
--   Dependencies:
--      - connman
-- =====================================================================================

local awful = require("awful")

local lgi = require("lgi")
local Gio = lgi.require("Gio")
local GLib = lgi.require("GLib")

-- -------------------------------------------------------------------------------------
-- Helper Functions

local function get_wifi_properties()
    local ret, err =
        system_bus:call_sync(
        "net.connman",
        "/net/connman/technology/wifi",
        "net.connman.Technology",
        "GetProperties",
        nil,
        nil,
        Gio.DBusCallFlags.NONE,
        -1
    )

    if err then
        error("Error: daemon wifi, could not get wifi properties")
    elseif not ret or #ret ~= 1 then
        return
    end

    data = ret.value[1]

    return {
        Powered = data.Powered,
        Connected = data.Connected
    }
end

-- -------------------------------------------------------------------------------------
-- Defining the Daemon

local daemon = {is_running = false}

function daemon.emit(data)
    if not data then
        data = get_wifi_properties()

        if not data then
            return
        end
    end

    if data.Powered ~= nil then
        awesome.emit_signal("daemons::wifi", "powered", data.Powered)
    end

    if data.Connected ~= nil then
        awesome.emit_signal("daemons::wifi", "connected", data.Connected)
    end
end

function daemon.run()
    daemon.is_running = true

    local sub_id =
        system_bus:signal_subscribe(
        "net.connman",
        "net.connman.Technology",
        "PropertyChanged",
        nil,
        nil,
        Gio.DBusSignalFlags.NONE,
        function(_, _, _, _, _, data)
            name = data.value[1]
            value = data.value[2].value

            data = {}
            data[name] = value

            daemon.emit(data)
        end
    )

    if not sub_id then
        error("Error: daemon wifi, could not connect to system bus")
    end

    GLib.MainLoop():run()
end

-- -------------------------------------------------------------------------------------
-- Connect Handlers

awesome.connect_signal(
    "controls::wifi",
    function(command)
        local script

        if command == "disable" then
            script = "connmanctl disable wifi"
        elseif command == "enable" then
            script = "connmanctl enable wifi"
        else
            error("Error: daemon wifi, command '" .. command .. "' not found")
        end

        awful.spawn.with_shell(script)
    end
)

-- -------------------------------------------------------------------------------------
return daemon
