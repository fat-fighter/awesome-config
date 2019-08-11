--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful").startscreen.wifi

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

--------------------------------------------------------------------------------
-- Creating the Wifi Widget

local wifi_icon = wibox.widget {
	image         = beautiful.icon_off,
	resize        = true,
	forced_width  = beautiful.icon_size,
	forced_height = beautiful.icon_size,
	widget        = wibox.widget.imagebox
}

local wifi = wibox.widget {
	bg                 = beautiful.bg.off or "#dddddd",
	shape              = gears.shape.circle,
	forced_width       = beautiful.width,
	forced_height      = beautiful.height,
	shape_border_color = beautiful.border_color_off,
	shape_border_width = beautiful.border_width,
	widget             = wibox.container.background
}

local centered = helpers.center_align_widget
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
		function ()
			bg = wifi.bg
			wifi.bg = beautiful.bg.hover
		end,
		function ()
			wifi.bg = bg
		end
	)
end

--------------------------------------------------------------------------------
-- Adding Startup and Update Functions to Update Widget on Wifi Status Change

wifi.enabled = false

local function startup_widget()
	awful.spawn.easy_async_with_shell(
		"connmanctl state | head -1",
		function(stdout)
			local status = stdout:match("= .*$"):sub(3, -2)

			wifi.enabled = true
			wifi_icon.image         = beautiful.icon_on
			wifi.shape_border_color = beautiful.border_color_on

			if status == "online" or status == "ready" then
				wifi.bg = beautiful.bg.conn or "#0000ff"
			elseif status == "idle" then
				awful.spawn.easy_async_with_shell(
					"connmanctl scan wifi",
					function(stdout, stderr)
						if stderr:sub(1, 5) == "Error" then
							wifi.bg                 = beautiful.bg.off or "#dddddd"
							wifi.enabled            = false
							wifi_icon.image         = beautiful.icon_off
							wifi.shape_border_color = beautiful.border_color_off
						else
							wifi.bg = beautiful.bg.on or "#333333"
						end
					end
				)
			end
		end
	)
end

--startup_widget()

local function update_widget(line)
	local property = line:match("[^%s]+ ="):sub(1, -3):lower()
	local status = line:match("= [01]"):sub(3, -1)

	if property == "powered" then
		if status == "0" then
			wifi.bg                 = beautiful.bg.off or "#dddddd"
			wifi.enabled            = false
			wifi_icon.image         = beautiful.icon_off
			wifi.shape_border_color = beautiful.border_color_off
		else
			wifi.bg                 = beautiful.bg.on or "#333333"
			wifi.enabled            = true
			wifi_icon.image         = beautiful.icon_on
			wifi.shape_border_color = beautiful.border_color_on
		end
	end

	if property == "connected" then
		if status == "0" then
			wifi.bg = beautiful.bg.on or "#333333"
		else
			wifi.bg = beautiful.bg.conn or "#0000ff"
		end
	end
end

startup_widget()

-- Sleeps until connmanctl detects an event (wifi on/off/connected)
local connman_script = [[
	bash -c "
		connman-monitor | grep --line-buffered 'technology/wifi'
	"
]]

awful.spawn.with_line_callback(connman_script, {
	stdout = function(line)
		update_widget(line)
	end
})

--------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

wifi:buttons(
	gears.table.join(
		-- Left Click - Stop Timer
		awful.button({ }, 1, function ()
			if wifi.enabled then
				awful.spawn.with_shell("connmanctl disable wifi")
			else
				awful.spawn.with_shell("connmanctl enable wifi")
			end
		end),
		awful.button({ }, 3, function ()
			awful.spawn("connman-gtk")
		end)
	)
)

--------------------------------------------------------------------------------
return wifi
