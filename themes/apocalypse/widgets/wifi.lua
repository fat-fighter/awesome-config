-- =====================================================================================
--   Name:       wifi.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/widgets ...
--               ... wifi.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based wifi widget
-- =====================================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful").controlpanel.wifi

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")
local wifi_daemon = require("daemons.wifi")

-- -------------------------------------------------------------------------------------
-- Creating the Wifi Widget

local wifi_icon = wibox.widget {
	image = beautiful.icon_off,
	resize = true,
	forced_width = beautiful.icon_size,
	forced_height = beautiful.icon_size,
	widget = wibox.widget.imagebox
}

local wifi = wibox.widget {
	bg = beautiful.bg.off,
	shape = gears.shape.circle,
	forced_width = beautiful.width,
	forced_height = beautiful.height,
	shape_border_color = beautiful.border_color_off,
	shape_border_width = beautiful.border_width,
	widget = wibox.container.background
}

local centered = helpers.centered
wifi:setup {
	nil,
	centered(wifi_icon, "horizontal"),
	nil,
	expand = "none",
	layout = wibox.layout.align.vertical
}

if beautiful.bg.hover then
	local bg = wifi.bg
	helpers.add_clickable_effect(
		wifi,
		function()
			bg = wifi.bg
			wifi.bg = beautiful.bg.hover
		end,
		function()
			wifi.bg = bg
		end
	)
end

-- -------------------------------------------------------------------------------------
-- Adding Startup and Update Functions to Update Widget on Wifi Status Change

wifi.enabled = false

local function update_widget(name, value)
	if name == "powered" then
		if value then
			wifi.bg = beautiful.bg.on
			wifi.enabled = true
			wifi_icon.image = beautiful.icon_on
			wifi.shape_border_color = beautiful.border_color_on
		else
			wifi.bg = beautiful.bg.off
			wifi.enabled = false
			wifi_icon.image = beautiful.icon_off
			wifi.shape_border_color = beautiful.border_color_off
		end
	end

	if name == "connected" then
		if value then
			wifi.bg = beautiful.bg.conn
		else
			wifi.bg = beautiful.bg.on
		end
	end
end

awesome.connect_signal("daemons::wifi", update_widget)

gears.timer.delayed_call(
    function()
        wifi_daemon.emit()
        if not wifi_daemon.is_running then
            wifi_daemon.run()
        end
    end
)

-- -------------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

wifi:buttons(
	gears.table.join(
		-- Left Click - Stop Timer
		awful.button({}, 1, function()
			if wifi.enabled then
				awful.spawn.with_shell("connmanctl disable wifi")
			else
				awful.spawn.with_shell("connmanctl enable wifi")
			end
		end),
		awful.button({}, 3, function()
			awful.spawn("connman-gtk")
		end)
	)
)

-- -------------------------------------------------------------------------------------
return wifi
