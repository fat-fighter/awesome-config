--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful").startscreen.bluetooth

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

--------------------------------------------------------------------------------
-- Creating the Wifi Widget

local bluetooth_icon = wibox.widget {
	image         = beautiful.icon_off,
	resize        = true,
	forced_width  = beautiful.icon_size,
	forced_height = beautiful.icon_size,
	widget        = wibox.widget.imagebox
}

local bluetooth = wibox.widget {
	bg                 = beautiful.bg.off or "#dddddd",
	shape              = gears.shape.circle,
	forced_width       = beautiful.width,
	forced_height      = beautiful.height,
	shape_border_color = beautiful.border_color_off,
	shape_border_width = beautiful.border_width,
	widget             = wibox.container.background
}

local centered = helpers.center_align_widget
bluetooth:setup {
	nil,
	centered(bluetooth_icon, "horizontal"),
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical
}

if beautiful.bg.hover then
	local bg = bluetooth.bg
	helpers.add_clickable_effect(
		bluetooth,
		function ()
			bg = bluetooth.bg
			bluetooth.bg = beautiful.bg.hover
		end,
		function ()
			bluetooth.bg = bg
		end
	)
end

--------------------------------------------------------------------------------
-- Adding Startup and Update Functions to Update Widget on Wifi Status Change

local function update_widget(line)
	local property = line:match("[^%s]+ ="):sub(1, -3):lower()
	local status = line:match("= .*$"):sub(3, -1):lower()

	if property == "powered" then
		if status == "false" then
			bluetooth.bg                 = beautiful.bg.off or "#dddddd"
			bluetooth.enabled            = false
			bluetooth_icon.image         = beautiful.icon_off
			bluetooth.shape_border_color = beautiful.border_color_off
		else
			bluetooth.bg                 = beautiful.bg.on or "#333333"
			bluetooth.enabled            = true
			bluetooth_icon.image         = beautiful.icon_on
			bluetooth.shape_border_color = beautiful.border_color_on
		end
	elseif property == "connected" then
		if status == "false" then
			bluetooth.bg = beautiful.bg.on or "#333333"
		else
			bluetooth.bg = beautiful.bg.conn or "#0000ff"
		end
	end
end

-- Sleeps until connmanctl detects an event (bluetooth on/off/connected)
local connman_script = [[
	bash -c "
		bluez-monitor | grep --line-buffered -E 'Powered|Connected'
	"
]]

awful.spawn.with_line_callback(connman_script, {
	stdout = function(line)
		update_widget(line)
	end
})

--------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

bluetooth:buttons(
	gears.table.join(
		-- Left Click - Stop Timer
		awful.button({ }, 1, function ()
			if bluetooth.enabled then
				awful.spawn.with_shell("bluetoothctl power off")
			else
				awful.spawn.with_shell("bluetoothctl power on")
			end
		end),
		awful.button({ }, 3, function ()
			awful.spawn("blueman-manager")
		end)
	)
)

--------------------------------------------------------------------------------
return bluetooth
