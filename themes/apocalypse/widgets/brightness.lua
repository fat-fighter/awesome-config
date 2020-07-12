-- =====================================================================================
--   Name:       brightness.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/config-awesom/themes/apocalypse/widgets ...
--               ... brightness.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based brightness widget
-- =====================================================================================

local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful").controlpanel.brightness

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local slider = require("widgets.slider").create_slider
local brightness_daemon = require("daemons.brightness")

-- -------------------------------------------------------------------------------------
-- Defining the Widget

local brightness = slider(
    beautiful,
    function(val)
        awesome.emit_signal("controls::brightness", "set", val)
    end
)
brightness.icon.image = beautiful.icon

local function update_widget(cmd, val)
    if cmd == "changed" then
        brightness.bar.value = val
    end
end

-- Connect to daemon signal {{{
awesome.connect_signal("properties::brightness", update_widget)

gears.timer.delayed_call(
    function()
        brightness_daemon.emit()
        if not brightness_daemon.is_running then
            brightness_daemon.run()
        end
    end
)
-- }}}

-- -------------------------------------------------------------------------------------
-- Button Controls

brightness:buttons(
	gears.table.join(
		awful.button(
            {},
            4,
            function()
                awesome.emit_signal("controls::brightness", "increase")
		    end
        ),
		awful.button(
            {},
            5,
            function()
                awesome.emit_signal("controls::brightness", "decrease")
		    end
        )
	)
)

-- -------------------------------------------------------------------------------------
return brightness
