-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful").startscreen.weather

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the Webcam Widget

local weather_icon = wibox.widget {
	image = beautiful.icons.default,
	resize = true,
	forced_width = beautiful.icon_size,
	forced_height = beautiful.icon_size,
	widget = wibox.widget.imagebox
}

local weather_temp = wibox.widget {
    text = "-",
    align = "center",
    valign = "center",
    font = beautiful.font,
    widget = wibox.widget.textbox
}

local weather_temp_icon = wibox.widget {
	image = beautiful.icons.default,
	resize = true,
	forced_width = beautiful.temp_icon_size,
	forced_height = beautiful.temp_icon_size,
	widget = wibox.widget.imagebox
}

local centered = helpers.center_align_widget

local tt = {
    weather_temp,
    shape = helpers.rrect(5),
    widget = wibox.container.background
}

local weather = wibox.widget {
	centered({
		centered(weather_icon, "horizontal"),
        helpers.vpad(2),
        centered({
            weather_temp,
            helpers.hpad(1),
            weather_temp_icon,
            layout = wibox.layout.align.horizontal
        }, "horizontal"),
		layout = wibox.layout.align.vertical
    }, "vertical"),
	bg = beautiful.bg,
    shape = helpers.rrect(beautiful.border_radius or 0),
	forced_width = beautiful.width,
	forced_height = beautiful.height,
	widget = wibox.container.background
}

-- -------------------------------------------------------------------------------------
-- Adding Update Functions to Update Weather periodically

local app_id = "d0d6a88b3a4ef6f54248a8055af908b4"
local city_id = "5128581"
local units = "metric" -- | "imperial"

local icons = beautiful.icons

if units == "metric" then
    weather_temp_icon.image = icons.celcius
elseif units == "imperial" then
    weather_temp_icon.image = icons.fahrenheit
end

-- Gets the weather status using openweathermap API
local weather_details_script = [[
    bash -c '
        KEY="]] .. app_id .. [["
        CITY="]] .. city_id .. [["
        UNITS="]] .. units .. [["

        weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$KEY&id=$CITY&units=$UNITS")

        if [ ! -z "$weather" ]; then
            weather_temp=$(echo "$weather" | jq ".main.temp" | cut -d "." -f 1)
            weather_icon=$(echo "$weather" | jq -r ".weather[].icon" | head -1)
            weather_description=$(echo "$weather" | jq -r ".weather[].description" | head -1)

            echo "$weather_icon" "$weather_description"@@"$weather_temp"
        else
            echo "..."
        fi
    '
]]

local update_interval = 1200

-- Writing the update function
awful.widget.watch(weather_details_script, update_interval, function(widget, stdout)
    local icon_code = string.sub(stdout, 1, 3)
    local weather_details = string.sub(stdout, 5)

    weather_details = string.gsub(weather_details, '^%s*(.-)%s*$', '%1')
    weather_details = string.gsub(weather_details, '%-0', '0')
    weather_details = weather_details:sub(1,1):upper()..weather_details:sub(2)

    -- local description = weather_details:match('(.*)@@')

    local temperature = weather_details:match('@@(.*)')
    weather_temp.markup = helpers.colorize_text(temperature, beautiful.fg)

    local dn = string.sub(icon_code, 3, 3)

    if string.find(icon_code, "01") then
        weather_icon.image = icons[dn .. "clear"]
    elseif string.find(icon_code, "02") then
        weather_icon.image = icons[dn .. "cloud"]
    elseif string.find(icon_code, "03") or string.find(icon_code, "04") then
        weather_icon.image = icons["cloudy"]
    elseif string.find(icon_code, "09") or string.find(icon_code, "10") then
        weather_icon.image = icons[dn .. "rain"]
    elseif string.find(icon_code, "11") then
        weather_icon.image = icons["storm"]
    elseif string.find(icon_code, "13") then
        weather_icon.image = icons["snow"]
    elseif string.find(icon_code, "50") then
        weather_icon.image = icons["mist"]
    else
        weather_icon.image = icons["default"]
    end
end)

-- -------------------------------------------------------------------------------------
return weather
