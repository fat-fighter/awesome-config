-- =====================================================================================
--   Name:       weather.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/widgets ...
--               ... controlpanel/weather.lua
--   License:    The MIT License (MIT)
--
--   Custom theme based weather widget
-- =====================================================================================

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful").controlpanel.weather

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")
local lunajson = require("modules.lunajson")

-- -------------------------------------------------------------------------------------
-- Creating the Webcam Widget

local weather_icon =
    wibox.widget {
    image = beautiful.icons.default,
    resize = true,
    forced_width = beautiful.icon_size,
    forced_height = beautiful.icon_size,
    widget = wibox.widget.imagebox
}

local temperature =
    wibox.widget {
    text = "-",
    align = "center",
    valign = "center",
    font = beautiful.temperature.font,
    widget = wibox.widget.textbox
}

local temperature_icon =
    wibox.widget {
    image = beautiful.icons.default,
    resize = true,
    forced_width = beautiful.temp_icon_size,
    forced_height = beautiful.temp_icon_size,
    widget = wibox.widget.imagebox
}

local details =
    wibox.widget {
    text = "---",
    align = "right",
    valign = "center",
    font = beautiful.details.font,
    widget = wibox.widget.textbox
}

local weather = {
    {
        {
            nil,
            nil,
            {
                temperature,
                helpers.hpad(1),
                temperature_icon,
                helpers.hpad(1),
                layout = wibox.layout.fixed.horizontal
            },
            layout = wibox.layout.align.vertical
        },
        {
            weather_icon,
            layout = wibox.layout.align.vertical
        },
        {
            helpers.empty_widget,
            details,
            helpers.vpad(0),
            layout = wibox.layout.align.vertical
        },
        layout = wibox.layout.align.horizontal
    },
    top = beautiful.margin.top,
    right = beautiful.margin.right,
    bottom = beautiful.margin.bottom,
    left = beautiful.margin.left,
    forced_height = beautiful.height,
    widget = wibox.container.margin
}

-- -------------------------------------------------------------------------------------
-- Adding Update Functions to Update Weather periodically

local app_id = "d0d6a88b3a4ef6f54248a8055af908b4"
local city_id = "5128581"
local units = "metric" -- | "imperial"

local icons = beautiful.icons

if units == "metric" then
    temperature_icon.image = icons.celcius
elseif units == "imperial" then
    temperature_icon.image = icons.fahrenheit
end

-- Gets the weather status using openweathermap API
local subscribe_script =
    [[
    bash -c '
        KEY="]] ..
    app_id ..
        [["
        CITY="]] ..
            city_id ..
                [["
        UNITS="]] ..
                    units ..
                        [["

        curl -sf "http://api.openweathermap.org/data/2.5/weather?APPID=$KEY&id=$CITY&units=$UNITS"
    '
]]

function update_widget()
    awful.spawn.easy_async_with_shell(
        subscribe_script,
        function(data)
            data = lunajson.decode(data)

            local temp = math.floor(data.main.temp + 0.5)
            temperature.markup = helpers.colorize_text(temp, beautiful.temperature.fg)

            local icon_code = data.weather[1].icon
            local dn = icon_code:sub(3, 3)
            icon_code = icon_code:sub(1, 2)

            local min_temp = math.floor(data.main.temp_min + 0.5)
            local max_temp = math.floor(data.main.temp_max + 0.5)

            if min_temp < 10 then
                min_temp = " " .. min_temp
            end
            if max_temp < 10 then
                max_temp = " " .. max_temp
            end

            details.markup =
                helpers.colorize_text(
                "min: " .. min_temp .. "°  .  " .. "max: " .. max_temp .. "°",
                beautiful.details.fg
            )

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
        end
    )
end

gears.timer {
    timeout = 1200,
    call_now = true,
    autostart = true,
    callback = update_widget
}

-- -------------------------------------------------------------------------------------
return weather
