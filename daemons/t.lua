-- =====================================================================================
--   Name:       bluetooth.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/daemons/bluetooth.lua
--   License:    The MIT License (MIT)
--
--   Daemon for bluetooth control
--
--   Note: This daemon requires bluez and bluez-utils to be installed
-- =====================================================================================

-- local awful = require("awful")
local bluez = require("bluezdbus")
local bus = bluez.get_system_bus()

-- local unpack = bluez.helpers.unpack_variant

-- -------------------------------------------------------------------------------------
-- Defining Local Variables

local manager = bluez.Manager:new(bus)



local adapters = {}
for _, path in ipairs(manager:get_adapters()) do
    print(path)
    print(bluez.Adapter:new(bus, path))
--     adapters[path] = bluez.Adapter:new(bus, path)
end
-- local primary_adapter = manager:get_active_adapter()

function add_interface(args)
    print(args)
end

function remove_interface(args)
    print(args)
end

manager.InterfacesAdded(nil, add_interface)
manager.InterfacesRemoved(nil, remove_interface)

bluez.run_main_loop()
