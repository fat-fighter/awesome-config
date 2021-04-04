-- =====================================================================================
--   Name:       mpris.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/daemons/mpris.lua
--   License:    The MIT License (MIT)
--
--   Daemon for media (mpris) control
-- =====================================================================================

local lgi = require("lgi")
local Gio = lgi.require("Gio")
local GLib = lgi.require("GLib")

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local h = require("modules.dbus.helpers")
local proxy = require("modules.dbus.proxy")

-- -------------------------------------------------------------------------------------
-- Dbus Proxy Definitions + Helpers

local services =
    proxy.new(
    session_bus,
    "org.freedesktop.DBus",
    "/org/freedesktop/DBus",
    "org.freedesktop.DBus"
)

local function player_proxy(name)
    return proxy.new(
        session_bus,
        "org.mpris.MediaPlayer2." .. name,
        "/org/mpris/MediaPlayer2",
        "org.mpris.MediaPlayer2.Player"
    )
end

-- -------------------------------------------------------------------------------------
-- Helper Functions

local function clean_metadata(data)
    local cleaned = {}
    for key, value in pairs(data) do
        cleaned[key:gsub("xesam:", "")] = value
    end

    return cleaned
end

local function run_func(player, func)
    player:call("org.mpris.MediaPlayer2.Player", func)
end

local function attach_properties(players)
    if not players._name then
        for _, player in pairs(players) do
            attach_properties(player)
        end
    else
        players.metadata =
            h.unpack_variant(
            players:call(
                "org.freedesktop.DBus.Properties",
                "GetAll",
                GLib.Variant("(s)", {"org.mpris.MediaPlayer2.Player"})
            )
        )
    end
end

-- -------------------------------------------------------------------------------------
-- Defining the Daemon

local daemon = {
    is_running = false,
    players = {},
    active_player = nil
}

function daemon.get_players()
    local session_dests = h.unpack_variant(services.ListNames())
    local players = {}

    for i = 1, #session_dests do
        local name = session_dests[i]:match("^org%.mpris%.MediaPlayer2%.(.+)")
        if name then
            players[name] = player_proxy(name)
        end
    end

    daemon.players = players
end

function daemon.filter_running_players()
    attach_properties(daemon.players)
    for name, player in pairs(daemon.players) do
        if player.metadata.PlaybackStatus == "Stopped" then
            daemon.players[name] = nil
        end
    end
end

function daemon.get_active_player(players, active_player)
    local active_player_, first
    local active_found = false
    for name, player in pairs(players) do
        if first == nil then
            first = player
        end

        -- Custom preference for youtube music {{{
        if name == "youtube-music-desktop-app" then
            first = player
        end
        -- }}}

        active_found =
            active_found or
            (active_player ~= nil and player._name == active_player._name)

        if player.metadata.PlaybackStatus == "Playing" then
            active_player_ = player
        end
    end

    if active_found then
        attach_properties(active_player)
        if active_player.metadata.PlaybackStatus == "Playing" or not active_player_ then
            active_player_ = active_player
        end
    end
    if not active_player_ then
        active_player_ = first
    end

    return active_player_
end

function daemon.update()
    daemon.get_players()
    daemon.filter_running_players()
    daemon.active_player =
        daemon.get_active_player(daemon.players, daemon.active_player)
end

function daemon.emit()
    daemon.update()

    if daemon.active_player then
        awesome.emit_signal(
            "daemons::mpris",
            "playback",
            daemon.active_player.metadata.PlaybackStatus
        )
        awesome.emit_signal(
            "daemons::mpris",
            "metadata",
            clean_metadata(daemon.active_player.metadata.Metadata)
        )
    else
        awesome.emit_signal("daemons::mpris", "playback", "Stopped")
    end
end

function daemon.run()
    daemon.is_running = true

    local sub_id =
        session_bus:signal_subscribe(
        nil,
        "org.freedesktop.DBus.Properties",
        "PropertiesChanged",
        "/org/mpris/MediaPlayer2",
        nil,
        Gio.DBusSignalFlags.NONE,
        function()
            daemon.emit()
        end
    )

    if not sub_id then
        error("Error: daemon mpris, could not connect to session bus")
    end

    GLib.MainLoop():run()
end

-- -------------------------------------------------------------------------------------
-- Connect Handlers

awesome.connect_signal(
    "controls::mpris",
    function(command)
        daemon.update()
        if not daemon.active_player then
            return
        end

        if command == "toggle" then
            run_func(daemon.active_player, "PlayPause")
        elseif command == "play" then
            run_func(daemon.active_player, "Play")
        elseif command == "pause" then
            for _, player in pairs(daemon.players) do
                run_func(player, "Pause")
            end
        elseif command == "next" then
            run_func(daemon.active_player, "Next")
        elseif command == "prev" then
            run_func(daemon.active_player, "Previous")
        elseif command == "stop" then
            run_func(daemon.active_player, "Stop")
        else
            error("Error: daemon mpris, command '" .. command .. "' not found")
        end
    end
)

-- -------------------------------------------------------------------------------------
return daemon
