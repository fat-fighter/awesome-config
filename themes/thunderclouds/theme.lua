--
--    ███     ████                                  ████
--   ░███    ░░███                                 ░░███
--   ██████   ░███      █████ ████  █████████       ░███   ██████   ████████
--  ░░███░    ░███      ░███ ░███  ░░███░░███    ███████  ███░░███  ░░███░░███
--   ░███     ░███████  ░███ ░███   ░███ ░███   ███░░███ ░███████    ░███ ░░░
--   ░███  █  ░███░░███ ░███ ░███   ░███ ░███  ░███░░███ ░███░░░     ░███
--   ░░████   ████░░███ ░████████   █████░████ ░░██████  ░░███████   █████
--    ░░░░   ░░░░  ░░░  ░░░░░░░░   ░░░░░ ░░░░   ░░░░░░    ░░░░░░░   ░░░░░
--                                          ████                            ████
--                 ██                     ░░███                           ░░███
--               ███              ██████   ░███    ██████  █████ ████      ░███   █████
--             ████              ███░░███  ░███   ███░░███ ░███ ░███    ███████ ░███░░
--           █████              ░███ ░░░   ░███  ░███ ░███ ░███ ░███   ███░░███  ░████
--             ████             ░███  ███  ░███  ░███ ░███ ░███ ░███  ░███░░███  ░░░███
--            ███               ░░██████   █████ ░░██████  ░████████  ░░██████   █████
--           ██                  ░░░░░░   ░░░░░   ░░░░░░   ░░░░░░░░    ░░░░░░   ░░░░░
--
-- =====================================================================================
--   Name:       thunder⚡clouds
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/thunderclouds/theme.lua
--   License:    The MIT License (MIT)
--
--   A dark UI theme for aweosme heavily based on elenapan's  dotfiles
--   (github.com/elenapan/dotfiles)
-- =====================================================================================

local theme_name = "thunderclouds"

local config_dir = os.getenv("HOME") .. "/.config/awesome/"
local theme_dir  = config_dir .. "themes/" .. theme_name .. "/"

local theme      = {}

----------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful        = require("awful")
local theme_assets = require("beautiful.theme_assets")
local dpi          = require("beautiful.xresources").apply_dpi

----------------------------------------------------------------------------------------
-- Setting Local Variables

-- Icon paths {{
local icons             = theme_dir .. "icons/"

local layout_icons      = icons .. "layout/"
local titlebar_icons    = icons .. "titlebar/"
local startscreen_icons = icons .. "startscreen/"
-- }}

-- Includes path {{
local includes = theme_dir .. "includes/"
-- }}

-- Screen size {{
local screen_width  = function()
	return awful.screen.focused().geometry.width
end
local screen_height = function()
	return awful.screen.focused().geometry.height
end
-- }}

-- Colors {{
local background_focus        = "#1B1D26"
local background_normal       = "#1B1D26"
local background_urgent       = "#FF4971"
local background_highlight    = "#FFEEEE18"

local foreground_title        = "#FF4971"
local foreground_focus        = "#FFFFFF"
local foreground_normal       = "#F7F7F7"
local foreground_urgent       = "#282A36"
local foreground_highlight    = "#7AB3CC"

local window_highlight_normal = "#252C36"
local window_highlight_focus  = "#15131A"
local window_highlight_urgent = "#FF4971"
-- }}

----------------------------------------------------------------------------------------
-- Setting Basic Theme Variables

-- DPI Settings {{
local dpi_scale = 1
local dpi       = function(x)
	return dpi(math.floor(x * dpi_scale))
end
theme.dpi = dpi
-- }}

-- Font Settings {{
local font_scale = 1
local font_size  = function(x)
	return math.floor(x * font_scale)
end
theme.font_size = font_size
-- }}

-- Wallpaper {{
theme.wallpaper = includes .. "wallpaper.jpg"
-- }}

-- Gaps {{
theme.useless_gap   = dpi(10)
theme.screen_margin = dpi(20)
-- }}

----------------------------------------------------------------------------------------
-- Configuring Client Window Settings

-- Borders {{
theme.window_border_radius = dpi(6)
theme.window_border_width  = dpi(0)

theme.window_border_focus  = window_highlight_focus
theme.window_border_normal = window_highlight_normal
theme.window_border_urgent = window_highlight_urgent
-- }}

-- Titlebars {{
local titlebar           = {}
titlebar.enabled         = true

titlebar.position        = "top" -- | "right" | "bottom" | "left"
titlebar.size            = dpi(40)

titlebar.imitate_borders = false
titlebar.border_size     = dpi(0)

titlebar.icon_size       = dpi(15)
titlebar.icon_spacing    = dpi(10)

titlebar.ontop_icon      = titlebar_icons .. "ontop.png"
titlebar.sticky_icon     = titlebar_icons .. "sticky.png"

titlebar.title           = {
    font    = "IBM Plex Mono Medium " .. font_size(12.5),
    align   = "center",
    enabled = true
}

titlebar.bg_normal       = window_highlight_normal
titlebar.fg_normal       = foreground_normal

titlebar.bg_focus        = window_highlight_focus
titlebar.fg_focus        = foreground_focus

titlebar.padding         = dpi(50)

theme.titlebar           = titlebar
-- }}

----------------------------------------------------------------------------------------
-- System Tray

local systray  = {}

systray.bg            = "#000000" -- Better looking system icons using gtk with black

systray.width         = dpi(200)
systray.height 		  = dpi(50)
systray.margin        = dpi(10)
systray.opacity       = 0.8
systray.spacing       = dpi(10)
systray.border_radius = dpi(6)

systray.x             = function()
	return screen_width() - dpi(20) - systray.width
end
systray.y             = function()
	return screen_height() - dpi(20) - systray.height
end

theme.systray         = systray

-- Icon spacing is not handled properly in wibox and has to be defined this way
--theme.systray_bg           = systray.bg
theme.systray_icon_spacing = systray.spacing


----------------------------------------------------------------------------------------
-- StartScreen

local startscreen              = { animation = {} }

startscreen.bg	               = foreground_normal .. "00"
startscreen.fg                 = foreground_normal

startscreen.bg_image           = includes .. "wallpaper-blur.jpg"

startscreen.opacity            = 1.0
startscreen.bg_opacity         = 1.0

startscreen.width              = screen_width
startscreen.height             = screen_height

startscreen.x                  = 0
startscreen.y                  = 0

startscreen.border_width       = 0
startscreen.border_color       = "#00000000"

startscreen.animation.style    = "opacity" -- | "slide_{lr|tb}" | "none"
startscreen.animation.easing   = "inOutQuart" -- For options, refer to tween.lua documentation
startscreen.animation.duration = 0.3

startscreen.border_radius      = 0

----------------------------------------------------------------------------------------
-- StartScreen Widgets

local column_widths = { dpi(500), dpi(330), dpi(402) }

-- Widget Box settings {{
local widgetbox         = {}

widgetbox.bg            = "#282F3777"
widgetbox.bg_hover      = "#484F5799"
widgetbox.margin        = dpi(6)
widgetbox.border_radius = dpi(12)
-- }}

-- Battery {{
local battery       = {}

battery.fg_normal   = foreground_normal
battery.fg_urgent   = background_urgent
battery.fg_charging = "#48dc60"

battery.font        = "Roboto " .. font_size(12)

battery.width       = dpi(40)
battery.height      = dpi(18)

battery.border      = { width = dpi(2), color = foreground_normal .. "99" }
battery.radius      = dpi(3)

battery.decoration  = dpi(7)

battery.low_icon    = startscreen_icons .. "low-battery.png"
battery.low_thresh  = 20
-- }}

-- Host {{
host      = {}
host.font = "Iosevka Medium " .. font_size(13)
-- }}

-- User {{
local user          = {}

user.logo           = config_dir .. "logo.png"
user.picture        = config_dir .. "avatar.png"

user.logo_height    = dpi(90)
user.picture_height = dpi(200)
-- }}

-- Datetime {{
local datetime         = {}

datetime.time          = {}
datetime.time.fg       = foreground_normal
datetime.time.font     = "BebasNeue Bold " .. font_size(60)

datetime.date          = {}
datetime.date.fg       = foreground_normal
datetime.date.font     = "BebasNeue " .. font_size(24)

datetime.location      = {}
datetime.location.fg   = foreground_title
datetime.location.font = "BebasNeue Medium " .. font_size(24)

datetime.timeblock     = { margin = dpi(20) }
-- }}

-- Calendar {{
local calendar         = {
	bg           = {},
	fg           = {},
	font         = {},
	shape        = {},
	padding      = {},
	border_color = {},
	border_width = {}
}

calendar.font.focus    = "Iosevka Bold " .. font_size(13)
calendar.font.header   = "BebasNeue Bold " .. font_size(22)
calendar.font.normal   = "Iosevka Light " .. font_size(13)
calendar.font.weekday  = "Iosevka Medium " .. font_size(14)
calendar.font.weekend  = "Iosevka Medium " .. font_size(14)
calendar.font.dweekend = "Iosevka Light " .. font_size(13)

calendar.bg.focus      = background_highlight
calendar.bg.dweekend   = background_focus .. "33"

calendar.fg.focus      = foreground_focus
calendar.fg.header     = foreground_title
calendar.fg.normal     = foreground_normal
calendar.fg.weekday    = foreground_highlight
calendar.fg.weekend    = foreground_highlight
calendar.fg.dweekend   = foreground_normal

calendar.shape.month   = function(cr, width, height)
	require("gears").shape.rounded_rect(cr, width, height, 10)
end

calendar.markup        = function(text, flag)
	if calendar.font[flag] then
		text = "<span font_desc='" .. calendar.font[flag] .. "'>" .. text .. "</span>"
	end

	return text
end

calendar.buttons_size  = dpi(20)
calendar.buttons_depth = dpi(15)

calendar.spacing       = dpi(10)
-- }}

-- Player {{
local player             = {}

player.icons             = {}

player.icons.next        = startscreen_icons .. "player-next.png"
player.icons.prev        = startscreen_icons .. "player-prev.png"

player.icons.play        = startscreen_icons .. "player-play.png"
player.icons.pause       = startscreen_icons .. "player-pause.png"

player.icons.size        = dpi(45)
player.icons.margin      = dpi(50)

player.fg                = { title = {}, artist = {} }
player.fg.title.playing  = foreground_normal
player.fg.title.paused   = foreground_normal
player.fg.title.stopped  = foreground_normal .. "33"

player.fg.artist.playing = foreground_normal
player.fg.artist.paused  = foreground_normal
player.fg.artist.stopped = foreground_normal .. "33"

player.font              = {
	title  = "Din Light " .. font_size(18),
	artist = "Iosevka " .. font_size(14)
}

player.scroll_speed      = 50
player.scroll_space      = dpi(100)

player.art_dir           = config_dir .. ".tmp/"
player.art_size          = dpi(80)

player.margin            = dpi(70)
-- }}

-- Controls {{
local controls             = {}

controls.bg                = widgetbox.bg
controls.bg_hover          = widgetbox.bg_hover

controls.widget_width      = dpi(90)
controls.widget_height     = dpi(90)

controls.border_radius     = widgetbox.border_radius

controls.icon_size         = dpi(30)

controls.inner_widget_size = dpi(55)
controls.inner_icon_size   = dpi(25)

controls.margin            = widgetbox.margin
controls.inner_margin      = (controls.widget_width - controls.inner_widget_size + controls.margin) * 2.0 / 3.0
-- }}

-- Brightness {{
local brightness         = { icons = {} }

brightness.icon          = startscreen_icons .. "brightness.png"
brightness.icon_size     = controls.inner_icon_size
brightness.icon_bottom   = controls.inner_margin / 2

brightness.bar_bg        = widgetbox.bg
brightness.controller_bg = foreground_highlight

brightness.width         = controls.widget_width
brightness.height        = (controls.widget_height + controls.margin) * 2

brightness.scale         = brightness.height / dpi(100)

brightness.border_radius = controls.border_radius
-- }}

-- Volume {{
local volume         = { icons = {} }

volume.icon_on       = startscreen_icons .. "volume-on.png"
volume.icon_mute     = startscreen_icons .. "volume-mute.png"
volume.icon_size     = controls.inner_icon_size
volume.icon_bottom   = controls.inner_margin / 2

volume.bar_bg        = widgetbox.bg
volume.controller_bg = foreground_highlight

volume.width         = controls.widget_width
volume.height        = (controls.widget_height + controls.margin) * 2

volume.scale         = volume.height / dpi(100)

volume.border_radius = controls.border_radius
-- }}

-- Wifi {{
local wifi            = { bg = {} }

wifi.icon_size        = controls.inner_icon_size

wifi.icon_on          = startscreen_icons .. "wifi-on.png"
wifi.icon_off         = startscreen_icons .. "wifi-off.png"

wifi.bg.on            = controls.bg .. "00"
wifi.bg.off           = controls.bg .. "00"
wifi.bg.conn          = foreground_normal .. "55"
wifi.bg.hover         = controls.bg_hover

wifi.width            = controls.inner_widget_size
wifi.height           = controls.inner_widget_size

wifi.border_width     = dpi(1)
wifi.border_color_on  = foreground_normal .. "BB"
wifi.border_color_off = foreground_normal .. "77"
-- }}

-- Bluetooth {{
local bluetooth            = { bg = {} }

bluetooth.icon_size        = controls.inner_icon_size

bluetooth.icon_on          = startscreen_icons .. "bluetooth-on.png"
bluetooth.icon_off         = startscreen_icons .. "bluetooth-off.png"

bluetooth.bg.on            = controls.bg .. "00"
bluetooth.bg.off           = controls.bg .. "00"
bluetooth.bg.conn          = foreground_normal .. "55"
bluetooth.bg.hover         = controls.bg_hover

bluetooth.width            = controls.inner_widget_size
bluetooth.height           = controls.inner_widget_size

bluetooth.border_width     = dpi(1)
bluetooth.border_color_on  = foreground_normal .. "BB"
bluetooth.border_color_off = foreground_normal .. "77"
-- }}

-- Screenshot {{
local screenshot         = {}

screenshot.bg            = controls.bg
screenshot.bg_hover      = controls.bg_hover

screenshot.width         = controls.widget_width
screenshot.height        = controls.widget_height

screenshot.icon          = startscreen_icons .. "screenshot.png"
screenshot.icon_size     = controls.icon_size

screenshot.border_radius = controls.border_radius
-- }}

-- Mail {{
local mail              = {}

mail.icon               = startscreen_icons .. "mail.png"
mail.icon_size          = controls.icon_size

mail.width              = controls.widget_width
mail.height             = controls.widget_height

mail.border_radius      = controls.border_radius

mail.bg                 = controls.bg
mail.bg_hover           = controls.bg_hover
mail.bg_notification    = background_urgent

mail.fg                 = foreground_urgent
mail.font               = "Iosevka Light " .. font_size(11)

mail.notification_size  = dpi(22)
mail.notification_shift = dpi(0)
-- }}

-- Calculator {{
local calculator         = {}

calculator.icon          = startscreen_icons .. "calculator.png"
calculator.icon_size     = controls.icon_size

calculator.width         = controls.widget_wid2h
calculator.height        = controls.widget_height

calculator.border_radius = controls.border_radius

calculator.bg            = controls.bg
calculator.bg_hover      = controls.bg_hover
-- }}

-- Webcam {{
local webcam         = {}

webcam.icon          = startscreen_icons .. "webcam.png"
webcam.icon_size     = controls.icon_size

webcam.width         = controls.widget_width
webcam.height        = controls.widget_height

webcam.border_radius = controls.border_radius

webcam.bg            = controls.bg
webcam.bg_hover      = controls.bg_hover
-- }}

-- Weather {{
local weather          = {}

weather.icon_size      = dpi(60)
weather.temp_icon_size = dpi(40)
weather.icons          = {
    mist       = startscreen_icons .. "weather_mist.png",
    snow       = startscreen_icons .. "weather_snow.png",
    storm      = startscreen_icons .. "weather_storm.png",
    cloudy     = startscreen_icons .. "weather_cloudy.png",
    dclear     = startscreen_icons .. "weather_dclear.png",
    nclear     = startscreen_icons .. "weather_nclear.png",
    dcloud     = startscreen_icons .. "weather_dcloud.png",
    ncloud     = startscreen_icons .. "weather_ncloud.png",
    drain      = startscreen_icons .. "weather_drain.png",
    nrain      = startscreen_icons .. "weather_nrain.png",
    default    = startscreen_icons .. "weather_default.png",
    celcius    = startscreen_icons .. "weather_celcius.png",
    fahrenheit = startscreen_icons .. "weather_fahrenheit.png",
}

weather.fg             = foreground_normal
weather.font           = "BebasNeue " .. font_size(40)

weather.width          = (controls.widget_width + controls.margin) * 2
weather.height         = (controls.widget_height + controls.margin) * 2

weather.border_radius  = controls.border_radius

weather.bg             = controls.bg
weather.bg_hover       = controls.bg_hover

weather.shadow_radius  = controls.border_radius
-- }}

-- Alarm {{
local alarm         = {}

alarm.icon          = startscreen_icons .. "alarm.png"
alarm.icon_size     = controls.icon_size

alarm.width         = controls.widget_width
alarm.height        = controls.widget_height

alarm.border_radius = controls.border_radius

alarm.bg            = controls.bg
alarm.bg_hover      = controls.bg_hover
-- }}

-- Notes {{
local notes           = { title = {}, text = {} }

notes.title.font      = "BebasNeue Medium " .. font_size(24)
notes.title.fg        = foreground_title

notes.text.font       = "Iosevka Medium " .. font_size(13)
notes.text.fg         = foreground_normal

notes.text.heading_fg = foreground_highlight

notes.line_height     = 20

notes.margin          = controls.inner_margin

notes.edit_icon       = startscreen_icons .. "edit.png"
notes.edit_icon_size  = controls.inner_icon_size
-- }}

-- Adding widget settings to theme {{
startscreen.host          = host
startscreen.mail          = mail
startscreen.user          = user
startscreen.wifi          = wifi
startscreen.alarm         = alarm
startscreen.notes         = notes
startscreen.player        = player
startscreen.volume        = volume
startscreen.webcam        = webcam
startscreen.battery       = battery
startscreen.weather       = weather
startscreen.calendar      = calendar
startscreen.controls      = controls
startscreen.datetime      = datetime
startscreen.bluetooth     = bluetooth
startscreen.widgetbox     = widgetbox
startscreen.calculator    = calculator
startscreen.screenshot    = screenshot
startscreen.brightness    = brightness
startscreen.column_widths = column_widths
-- }}

theme.startscreen      = startscreen

----------------------------------------------------------------------------------------
-- Hoteys Help

theme.hotkeys_bg               = background_normal
theme.hotkeys_fg	           = foreground_normal .. "88"
theme.hotkeys_border_width     = 0
theme.hotkeys_border_color     = background_normal
theme.hotkeys_modifiers_fg     = foreground_focus
theme.hotkeys_label_bg         = background_normal .. "00"
theme.hotkeys_label_fg	       = foreground_title
theme.hotkeys_font	           = "Iosevka Medium " .. font_size(16)
theme.hotkeys_description_font = "Iosevka Medium " .. font_size(14)
theme.hotkeys_group_margin     = dpi(50)

----------------------------------------------------------------------------------------
-- Notifications

local naughty         = {}

naughty.font          = "IBM Plex Mono Medium " .. font_size(12)

naughty.bg            = background_normal
naughty.fg            = foreground_normal

naughty.bg_critical   = background_urgent
naughty.fg_critical   = foreground_urgent

-- naughty.width      = dpi(..)
-- naughty.height     = dpi(..)
naughty.margin        = dpi(30)

naughty.opacity       = 0.95

naughty.border_width  = 0
naughty.border_color  = "#18E3C8"
naughty.border_radius = theme.window_border_radius

naughty.padding       = dpi(10)
naughty.spacing       = dpi(10)

naughty.icon_size     = dpi(60)

-- BUG: some notifications appear at top_right regardless
naughty.position      = "top_right"

theme.naughty         = naughty
----------------------------------------------------------------------------------------

return theme
