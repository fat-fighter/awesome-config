--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local gears     = require("gears")
local beautiful = require("beautiful").startscreen.volume

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local slider  = require("widgets.slider").create_slider
local helpers = require("helpers")

--------------------------------------------------------------------------------
-- Creating the Volume Widget

local volume = slider(beautiful, "volume set")

--------------------------------------------------------------------------------
-- Adding Update Function and Async Script to Update Slider on Volume Change

local mute

local function update_widget()
	awful.spawn.easy_async_with_shell(
		"volume get",
		function(stdout)
			local status = stdout:match("^[NHML]")
			local volume_ = tonumber(stdout:match("(%d+)"))

			if volume_ > 100 then
				volume_ = 100
			end

			if status == "N" then
				mute = true
				volume.bar.enabled = false

				volume.cover.bg = beautiful.controller_bg .. "00"
				volume.icon.image = beautiful.icon_mute
			else
				mute = false
				volume.bar.enabled = true

				volume.cover.bg = beautiful.controller_bg
				volume.icon.image = beautiful.icon_on
			end

			volume.bar.value = volume_
		end
	)
end

-- Call at beginning to read the current volume level
update_widget()

-- Sleeps until pactl detects an event (volume up/down/toggle mute)
local volume_script = [[
	bash -c "
		pactl subscribe 2> /dev/null | grep --line-buffered 'sink #'
	"
]]

awful.spawn.with_line_callback(volume_script, {
	stdout = function(line)
		update_widget()
	end
})

--------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

volume:buttons(
	gears.table.join(
		-- Right click - Mute / Unmute
		awful.button({ }, 3, function ()
			awful.spawn.with_shell("volume mute")
			
			if mute then
				mute = false
				volume.bar.enabled = true

				volume.cover.bg = beautiful.controller_bg
				volume.icon.image = beautiful.icon_on
			else
				mute = true
				volume.bar.enabled = false
				
				volume.cover.bg = beautiful.controller_bg .. "00"
				volume.icon.image = beautiful.icon_mute
			end
		end),
		-- Scroll - Increase / Decrease volume
		awful.button({ }, 4, function ()
			awful.spawn.with_shell("volume set +2")
		end),
		awful.button({ }, 5, function ()
			awful.spawn.with_shell("volume set -2")
		end)
	)
)

--------------------------------------------------------------------------------
return volume
