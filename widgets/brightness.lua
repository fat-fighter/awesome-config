--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local gears     = require("gears")
local beautiful = require("beautiful").startscreen.brightness

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local slider  = require("widgets.slider").create_slider
local helpers = require("helpers")

--------------------------------------------------------------------------------
-- Creating the Brightness Widget

local brightness      = slider(beautiful, "light -S")
brightness.icon.image = beautiful.icon

--------------------------------------------------------------------------------
-- Adding Update Function and Timer to Update Slider on Brightness Change

local function update_widget()
	awful.spawn.easy_async_with_shell(
		"light -G",
		function(stdout)
			local brightness_ = tonumber(stdout:match("(%d+)"))

			brightness.bar.value = brightness_
		end
	)
end

local timer = gears.timer {
    timeout   = 0.1,
	call_now  = true,
    autostart = true,
    callback  = update_widget
}

--------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

brightness:buttons(
	gears.table.join(
		-- Left Click - Stop Timer
		awful.button({ }, 1, function ()
			timer:stop()
		end),
		-- Scroll - Increase / Decrease volume
		awful.button({ }, 4, function ()
			awful.spawn.with_shell("light -A 2")
		end),
		awful.button({ }, 5, function ()
			awful.spawn.with_shell("light -U 2")
		end)
	)
)

--------------------------------------------------------------------------------
return brightness
