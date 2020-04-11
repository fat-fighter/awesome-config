-- =====================================================================================
--   Name:       mpris.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/daemons/mpris.lua
--   License:    The MIT License (MIT)
--
--   Daemon for media (mpris) control
--
--   Note: This daemon requires playerctl to be installed
-- =====================================================================================

local awful = require("awful")

local lgi = require("lgi")
local Gio = lgi.require("Gio")
local GLib = lgi.require("GLib")

-- -------------------------------------------------------------------------------------
-- Helper Functions

local function get_players()
    local ret, err =
        session_bus:call_sync(
        "org.freedesktop.DBus",
        "/org/freedesktop/DBus",
        "org.freedesktop.DBus",
        "ListNames",
        nil,
        GLib.VariantType("(as)"),
        Gio.DBusCallFlags.NONE,
        -1
    )

    if err then
        error("Could not get mpris players")
    elseif not ret or #ret ~= 1 then
        return
    end

    local players = {}
    local array = ret.value[1]

    for i = 1, #array do
        local player_name = array[i]:match("^org%.mpris%.MediaPlayer2%.(.+)")
        if player_name then
            players[#players + 1] = player_name
        end
    end

    return players
end

local function get_all_properties(player)
    local prop_path =
        GLib.Variant.new_tuple({GLib.Variant("s", "org.mpris.MediaPlayer2.Player")}, 1)

    local ret, err =
        session_bus:call_sync(
        "org.mpris.MediaPlayer2." .. player,
        "/org/mpris/MediaPlayer2",
        "org.freedesktop.DBus.Properties",
        "GetAll",
        prop_path,
        nil,
        Gio.DBusCallFlags.NONE,
        -1,
        nil
    )

    if err then
        print(err)
        error("Could not get mpris player " .. player .. "'s properties")
    elseif not ret or #ret ~= 1 then
        return nil
    end

    return ret
end

-- local function get_property(player, property)
--     local prop_path = {"org.mpris.MediaPlayer2.Player", property}
--
--     local ret, err =
--         session_bus:call_sync(
--         "org.mpris.MediaPlayer2." .. player,
--         "/org/mpris/MediaPlayer2",
--         "org.freedesktop.DBus.Properties",
--         "Get",
--         GLib.Variant("(ss)", prop_path),
--         GLib.VariantType("(v)"),
--         Gio.DBusCallFlags.NONE,
--         -1,
--         nil
--     )
--
--     if err then
--         print(err)
--         error("Could not get mpris player " .. player .. "'s property " .. property)
--     elseif not ret or #ret ~= 1 then
--         return
--     end
--
--     return ret
-- end

local function get_active_player()
    local players = get_players()

    if not players then
        return
    end

    local passive_player, passive_props

    for _, player in ipairs(players) do
        props = get_all_properties(player).value[1]

        if props.PlaybackStatus == "Playing" then
            return player, props
        elseif props.PlaybackStatus == "Paused" then
            passive_player, passive_props = player, props
        end
    end

    return passive_player, passive_props
end

local function extract_metadata(data)
    local metadata = {
        album = data["xesam:album"],
        title = data["xesam:title"]
    }

    local artist = data["xesam:artist"]

    if type(artist) == "string" then
        metadata.artist = artist
    elseif metadata.artist and #metadata.artist.value ~= 0 then
        local artists = metadata.artist.value
        local value = artists[1]

        for i = 2, #artists do
            value = value .. ", " .. artists[i]
        end

        metadata.artist = value
    end

    return metadata
end

-- -------------------------------------------------------------------------------------
-- Defining the Daemon

local daemon = {is_running = false}

function daemon.emit(data)
    if not data then
        _, data = get_active_player()

        if not data then
            return
        end
    end

    if data.PlaybackStatus then
        awesome.emit_signal("properties::mpris", "playback", data.PlaybackStatus)
    end

    if data.Metadata then
        local metadata = extract_metadata(data.Metadata)
        awesome.emit_signal("properties::mpris", "metadata", metadata)
    end
end

function daemon.run()
    daemon.is_running = true

    local sub_id =
        session_bus:signal_subscribe(
        nil,
        "org.freedesktop.DBus.Properties",
        "PropertiesChanged",
        nil,
        nil,
        Gio.DBusSignalFlags.NONE,
        function(_, _, _, _, _, data)
            daemon.emit(data.value[2])
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
        local script

        if command == "toggle" then
            script = "playerctl play-pause"
        elseif command == "play" then
            script = "playerctl play"
        elseif command == "pause" then
            script = "playerctl pause"
        elseif command == "next" then
            script = "playerctl next"
        elseif command == "prev" then
            script = "playerctl previous"
        elseif command == "stop" then
            script = "playerctl stop"
        else
            error("Error: daemon volume, command '" .. command .. "' not found")
        end

        awful.spawn.with_shell(script)
    end
)

-- -------------------------------------------------------------------------------------
return daemon
