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

local unpack = bluez.helpers.unpack_variant

-- -------------------------------------------------------------------------------------
-- Defining Local Variables

local manager = bluez.Manager:new(bus)

local adapters = {}
for _, path in ipairs(manager:get_adapters()) do
    adapters[path] = bluez.Adapter:new(bus, path)
end
-- local primary_adapter = manager:get_active_adapter()

-- -------------------------------------------------------------------------------------
-- Helper Functions

function add_interface(args)
    print(args)
    -- local path = unpack(args)[0]
    --
    -- local adapter = path:match("^/org/bluez/hci[0-9]+")
    -- if not adapter then
    --     return
    -- end
    --
    -- print(path, adapter)
    --
    -- if adapter == path then
    --     adapters[path] = bluez.Adapter:new(bus, path)
    --     primary_adapter = manager:get_active_adapter()
    --
    --     print("daemons::bluetooth", "adapter:added", adapter, args[2])
    --
    -- elseif path:match(adapter .. "/dev-.*") then
    --     device = path:sub(#adapter + 1)
    --     print(
    --         "daemons::bluetooth",
    --         "device:added",
    --         device,
    --         adapter,
    --         args[2]
    --     )
    -- end
end

function remove_interface(args)
    print(args)
    -- path = unpack(args)[0]
    --
    -- adapter = path:match("^/org/bluez/hci[0-9]+")
    -- if not adapter then
    --     return
    -- end
    --
    -- if adapter == path and adapters[path] then
    --     adapters[path] = nil
    --     active_adapter = manager:get_active_adapter()
    --     print("daemons::bluetooth", "adapter:added", adapter)
    -- elseif path:match(adapter .. "/dev-.*") then
    --     device = path:sub(#adapter + 1)
    --     print("daemons::bluetooth", "device:removed", device, adapter)
    -- end
end

-- -------------------------------------------------------------------------------------
-- Defining the Daemon

-- local daemon = {is_running = false}

-- function daemon.emit(data)
--     if data.Powered ~= nil then
--         print("daemons::bluetooth", "powered", data.Powered)
--     end
--
--     if data.Connected ~= nil then
--         print("daemons::bluetooth", "connected", data.Connected)
--     end
-- end
--
--
-- daemon.is_running = true

-- Binding signals {{{
manager.InterfacesAdded(nil, add_interface)
manager.InterfacesRemoved(nil, remove_interface)
-- }}}

bluez.run_main_loop()

-- function daemon.run()
--     daemon.is_running = true
--
--     -- Binding signals {{{
--     manager.InterfacesAdded(nil, add_interface)
--     manager.InterfacesRemoved(nil, remove_interface)
--     -- }}}
--
--     bluez.run_main_loop()
-- end
-- daemon.run()

-- -------------------------------------------------------------------------------------
-- Connect Handlers

-- awesome.connect_signal(
--     "controls::bluetooth",
--     function(command)
--         local script
--
--         if command == "disable" then
--             script = "connmanctl disable bluetooth"
--         elseif command == "enable" then
--             script = "connmanctl enable bluetooth"
--         else
--             error("Error: daemon bluetooth, command '" .. command .. "' not found")
--         end
--
--         awful.spawn.with_shell(script)
--     end
-- )

-- -------------------------------------------------------------------------------------
-- return daemon
