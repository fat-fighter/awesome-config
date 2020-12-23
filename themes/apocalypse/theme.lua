--
--  ███████████████████████████████████████████████████████████████████████████████████
--                                              ░██
--   █████   ███████   █████    █████   █████   ░██  ██     ██  ███████   ████   █████
--  ░░░░░██ ░░███░░█  ███░░██  ███░░██ ░░░░░██  ░██  ███    ██ ░░███░░█ ░███░   ███░░██
--   ██████  ░███ ░█ ░███ ░██ ░███ ░░   ██████  ░██ ░░███  ██   ░███ ░█  ░███  ░██████
--  ███░░██  ░██████ ░███ ░██ ░███  ██ ███░░██  ░██  ░░█████    ░██████  ░░░██ ░███░░
--  ░███████ ░███░░  ░░█████  ░░█████  ░███████ ████  ░░░██     ░███░░   ████  ░░██████
--  ░░░░░░░  ░██      ░░░░░    ░░░░░   ░░░░░░░ ░░░░   █  ██     ░██     ░░░░    ░░░░░░
--           ████                                    ░ ███      ████
--          ░░░░                                      ░░░      ░░░░
--
-- =====================================================================================
--   Name:       apocalypse
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/theme.lua
--   License:    The MIT License (MIT)
--
--   A night UI theme for aweosmewm
-- =====================================================================================

local theme = {name = "thunderclouds"}

----------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local xresources = require("beautiful.xresources")
local odpi = xresources.apply_dpi

----------------------------------------------------------------------------------------
-- Setting Local Variables

-- Icon paths {{{
local icons = theme_dir .. "icons/"

local titlebar_icons = icons .. "titlebar/"
local controlpanel_icons = icons .. "controlpanel/"
local notification_icons = icons .. "notifications/"
-- }}}

-- Includes path {{{
local includes = theme_dir .. "includes/"
-- }}}

-- Theme {{{
local colors = xresources.get_current_theme()
-- }}}

-- Colors {{{
local background_normal = "#1B1D26"
local background_urgent = "#FF4971"

local foreground_title = "#FF4971"
local foreground_focus = "#FFFFFF"
local foreground_urgent = "#282A36"

local window_highlight_normal = "#252C36"
local window_highlight_focus = "#15131A"
local window_highlight_urgent = "#FF4971"
-- }}}

----------------------------------------------------------------------------------------
-- Setting Basic Theme Variables

-- DPI Settings {{{
local dpi_scale = .75
local dpi = function(x)
    return odpi(math.ceil(x * dpi_scale))
end
theme.dpi = dpi
-- }}}

-- Font Settings {{{
local font_scale = .75
local font_size = function(x)
    return math.ceil(x * font_scale)
end
theme.font_size = font_size
-- }}}

-- Wallpaper {{{
theme.wallpaper = includes .. "wallpaper.jpg"
-- }}}

-- Gaps {{{
theme.useless_gap = dpi(15)
theme.screen_margin = dpi(10)
-- }}}

----------------------------------------------------------------------------------------
-- Configuring Client Window Settings

-- Borders {{{
theme.window_border_radius = dpi(0)
theme.window_border_width = dpi(0)

theme.window_border_focus = window_highlight_focus
theme.window_border_normal = window_highlight_normal
theme.window_border_urgent = window_highlight_urgent
-- }}}

-- Titlebars {{{
local titlebar = {}

titlebar.enabled = true

titlebar.position = "top" -- | "right" | "bottom" | "left"
titlebar.size = dpi(47)

titlebar.imitate_borders = false
titlebar.border_size = dpi(2)

titlebar.margin = dpi(10)

titlebar.icon_size = dpi(15)
titlebar.icon_spacing = dpi(10)

titlebar.ontop_icon = titlebar_icons .. "ontop.png"
titlebar.sticky_icon = titlebar_icons .. "sticky.png"

titlebar.sticky_bg = colors.color12
titlebar.ontop_bg = colors.color9

titlebar.title = {
    font = "Iosevka Medium " .. font_size(12),
    align = "center",
    enabled = true
}

titlebar.buttons = {
    enabled = true,
    props = {
        maximized = {
            normal_active = titlebar_icons .. "maximized-normal-active.png",
            normal_inactive = titlebar_icons .. "maximized-normal-inactive.png",
            focus_active = titlebar_icons .. "maximized-focus-active.png",
            focus_inactive = titlebar_icons .. "maximized-focus-inactive.png"
        },
        minimize = {
            normal = titlebar_icons .. "minimize-normal.png",
            normal_hover = titlebar_icons .. "minimize-normal-hover.png",
            focus = titlebar_icons .. "minimize-focus.png",
            focus_hover = titlebar_icons .. "minimize-focus-hover.png"
        },
        close = {
            normal = titlebar_icons .. "close-normal.png",
            normal_hover = titlebar_icons .. "close-normal-hover.png",
            focus = titlebar_icons .. "close-focus.png",
            focus_hover = titlebar_icons .. "close-focus-hover.png"
        }
    }
}

titlebar.bg_normal = colors.color0
titlebar.fg_normal = colors.color4

titlebar.bg_focus = colors.color6 .. "b3"
titlebar.fg_focus = colors.color15

titlebar.padding = dpi(50)

for button, props in pairs(titlebar.buttons.props) do
    for prop, val in pairs(props) do
        theme["titlebar_" .. button .. "_button_" .. prop] = val
    end
end

theme.titlebar = titlebar
-- }}}

----------------------------------------------------------------------------------------
-- Components

-- Systray {{{
local systray = {}

systray.bg = "#000000" -- Better looking system icons using gtk with black

systray.width = dpi(200)
systray.height = dpi(50)
systray.margin = dpi(10)
systray.opacity = 0.8
systray.spacing = dpi(10)
systray.border_radius = dpi(6)

systray.x = function(screen)
    return screen.workarea.x + screen.workarea.width - dpi(20) - systray.width
end
systray.y = function(screen)
    return screen.workarea.y + screen.workarea.height - dpi(20) - systray.height
end

-- Icon spacing is not handled properly in wibox and has to be defined this way
--theme.systray_bg = systray.bg
theme.systray_icon_spacing = systray.spacing

theme.systray = systray
-- }}}

-- Bar {{{
local bar = {}

bar.width = function(screen)
    return screen.workarea.width
end
bar.height = dpi(6)

bar.x = 0
bar.y = function(screen)
    return screen.workarea.height - bar.height
end

bar.border = {}

bar.bg = {
    selected = colors.color2 .. "99",
    urgent = colors.color1 .. "99",
    occupied = colors.color12 .. "77",
    empty = colors.color4 .. "99",
    active = colors.color9 .. "99"
}
bar.bar_bg = "#ffffff00"

bar.border = {
    radius = dpi(0),
    rounding = {bl = true, br = true}, -- tl = [t|f], tr = [t|f], br = [t|f], bl = [t|f]
    top = 0,
    right = 0,
    bottom = 0,
    left = 0,
    color = colors.color6 .. "99"
}

bar.separator = {
    width = dpi(0),
    color = colors.color7 .. "55"
}

theme.bar = bar
-- }}}

-- Controlpanel {{{

local controlpanel = {animation = {}}

controlpanel.bg = colors.color0 .. "bb"
controlpanel.fg = colors.color15

controlpanel.opacity = 1.0

controlpanel.width = dpi(650)
controlpanel.height = nil

-- controlpanel.shadow = {
--     top = 0,
--     right = dpi(50),
--     bottom = 0,
--     left = 0
-- }

controlpanel.x = 0
-- For right position {{
-- controlpanel.x = function(screen)
--     return screen.workarea.width - controlpanel.width
-- end
-- }}
controlpanel.y = 0

controlpanel.animation.style = "slide_lr" -- | "opacity" | "slide_{lr|rl|tb|bt}" | "none"
controlpanel.animation.easing = "inOutQuart" -- For options, refer to tween.lua documentation
controlpanel.animation.duration = 0.5

controlpanel.border = {
    radius = dpi(30),
    rounding = {}, -- tl = [t|f], tr = [t|f], br = [t|f], bl = [t|f]
    top = 0,
    right = 1,
    bottom = 0,
    left = 0,
    color = colors.color4 .. "55"
}

controlpanel.padding = {
    topbottom = dpi(30),
    leftright = dpi(70)
}
-- }}}

----------------------------------------------------------------------------------------
-- Controlpanel Widgets

-- Player {{{
local player = {}

player.width = controlpanel.width - 2 * controlpanel.padding.leftright
player.height = dpi(320)

player.bg = colors.color14 .. "20"

player.fg = {
    title = {
        playing = colors.color15,
        paused = colors.color15,
        stopped = colors.color15
    },
    artist = {
        playing = colors.color15,
        paused = colors.color15,
        stopped = colors.color15 .. "88"
    }
}

player.font = {
    title = "Iosevka Term Bold " .. font_size(16),
    artist = "Iosevka Etoile " .. font_size(14)
}

player.visualizer = {
    enabled = true,
    config = includes .. "cava-config",
    color = colors.color12 .. "16",
    spacing = dpi(15)
}

player.padding = {
    topbottom = dpi(45),
    leftright = dpi(20)
}

player.border_radius = dpi(0)

player.icons = {
    next = controlpanel_icons .. "player-next.png",
    prev = controlpanel_icons .. "player-prev.png",
    play = controlpanel_icons .. "player-play.png",
    pause = controlpanel_icons .. "player-pause.png",
    size = dpi(30),
    margin = dpi(60)
}

player.scroll_speed = 50
player.scroll_space = dpi(100)

player.art_dir = config_dir .. ".tmp/"
player.art_size = dpi(80)

player.shadow_size = dpi(0)
player.shadow_color = colors.color0
-- }}}

-- Weather {{{
local weather = {}

weather.icon_size = dpi(90)
weather.temp_icon_size = dpi(50)
weather.icons = {
    mist = controlpanel_icons .. "weather-mist.png",
    snow = controlpanel_icons .. "weather-snow.png",
    storm = controlpanel_icons .. "weather-storm.png",
    cloudy = controlpanel_icons .. "weather-cloudy.png",
    dclear = controlpanel_icons .. "weather-dclear.png",
    nclear = controlpanel_icons .. "weather-nclear.png",
    dcloud = controlpanel_icons .. "weather-dcloud.png",
    ncloud = controlpanel_icons .. "weather-ncloud.png",
    drain = controlpanel_icons .. "weather-drain.png",
    nrain = controlpanel_icons .. "weather-nrain.png",
    default = controlpanel_icons .. "weather-default.png",
    celcius = controlpanel_icons .. "weather-celcius.png",
    fahrenheit = controlpanel_icons .. "weather-fahrenheit.png"
}

weather.temperature = {
    fg = colors.color15,
    font = "BebasNeue " .. font_size(65)
}

weather.details = {
    fg = colors.color7,
    font = "Iosevka Aile " .. font_size(13)
}

weather.width = nil
weather.height = dpi(150)

weather.margin = {
    right = dpi(20),
    left = dpi(20)
}
-- }}}

-- Datetime {{{
local datetime = {}

datetime.time = {
    fg = colors.color15,
    width = dpi(210),
    height = dpi(100),
    font = "BebasNeue Book " .. font_size(80)
}

datetime.date = {
    fg = colors.color15,
    width = dpi(210),
    height = dpi(30),
    font = "BebasNeue " .. font_size(24)
}

datetime.location = {
    fg = colors.color1,
    width = dpi(210),
    height = dpi(30),
    font = "BebasNeue Medium " .. font_size(24)
}

datetime.margin = {
    top = dpi(-30),
    right = dpi(20)
}
-- }}}

-- Todo {{{
local todo = {}

todo.title = {
    font = "BebasNeue Medium " .. font_size(24),
    fg = colors.color1
}

todo.text = {
    font = "Iosevka Medium " .. font_size(12),
    fg = colors.color7,
    heading_fg = colors.color3,
    line_height = dpi(30)
}

todo.bg = colors.color14 .. "20"

todo.padding = {topbottom = dpi(30), leftright = dpi(30)}

todo.width = controlpanel.width - 2 * controlpanel.padding.leftright
todo.height = dpi(500)

todo.edit_icon = controlpanel_icons .. "edit.png"
todo.edit_icon_size = dpi(25)

todo.border_radius = dpi(0)

controlpanel.todo = todo
-- }}}

-- Volume {{{
local volume = {icons = {}}

volume.icon_size = dpi(22)
volume.icon_opacity = 0.7

volume.bar = {
    size = dpi(3),
    radius = dpi(1),
    color = colors.color6
}

volume.handle = {
    size = dpi(25),
    color = colors.color15
}

volume.cover = {
    size = dpi(3),
    radius = dpi(1),
    color = colors.color15
}

volume.width = dpi(300)
volume.height = dpi(50)

volume.scale = volume.width / 100

volume.low_icon = controlpanel_icons .. "volume-mute.png"
volume.high_icon = controlpanel_icons .. "volume-high.png"

volume.border_radius = dpi(0)
-- }}}

-- Battery {{{
local battery = {}

battery.fg_normal = colors.color15
battery.fg_urgent = colors.color1
battery.fg_charging = colors.color10

battery.font = "Iosevka Slab " .. font_size(13)

battery.width = dpi(40)
battery.height = dpi(18)

battery.border = {width = dpi(2), color = colors.color15 .. "99"}
battery.radius = dpi(0)

battery.decoration = dpi(7)

battery.low_icon = controlpanel_icons .. "low-battery.png"
battery.low_thresh = 20
-- }}}

-- Minicontrols {{{
local minicontrols = {}

minicontrols.bg = colors.color14 .. "20"
minicontrols.bg_hover = "#ffffff"

minicontrols.width = controlpanel.width - 2 * controlpanel.padding.leftright
minicontrols.height = dpi(100)

minicontrols.border_radius = dpi(0)

minicontrols.margin = dpi(30)
minicontrols.spacing = dpi(30)
minicontrols.shadow_size = dpi(0)
minicontrols.shadow_color = colors.color0
-- }}}

-- Wifi {{{
local wifi = {bg = {}}

wifi.icon_size = dpi(30)
wifi.width = dpi(55)
wifi.height = dpi(55)

wifi.icon_on = controlpanel_icons .. "wifi-on.png"
wifi.icon_off = controlpanel_icons .. "wifi-off.png"

wifi.bg.on = colors.color8 .. "00"
wifi.bg.off = colors.color8 .. "00"
wifi.bg.conn = colors.color12 .. "aa"
wifi.bg.hover = colors.color15 .. "55"

wifi.border_width = dpi(1)
wifi.border_color_on = colors.color15 .. "BB"
wifi.border_color_off = colors.color15 .. "77"
-- }}}

-- Bluetooth {{{
local bluetooth = {bg = {}}

bluetooth.icon_size = minicontrols.icon_size

bluetooth.icon_on = controlpanel_icons .. "bluetooth-on.png"
bluetooth.icon_off = controlpanel_icons .. "bluetooth-off.png"

bluetooth.bg.on = minicontrols.bg .. "00"
bluetooth.bg.off = minicontrols.bg .. "00"
bluetooth.bg.conn = colors.color15 .. "55"
bluetooth.bg.hover = minicontrols.bg_hover

bluetooth.border_width = dpi(1)
bluetooth.border_color_on = colors.color15 .. "BB"
bluetooth.border_color_off = colors.color15 .. "77"
-- }}}

-- Adding widget settings to theme {{{
controlpanel.wifi = wifi
controlpanel.player = player
controlpanel.volume = volume
controlpanel.battery = battery
controlpanel.weather = weather
controlpanel.datetime = datetime
controlpanel.minicontrols = minicontrols
controlpanel.bluetooth = bluetooth
-- }}}

theme.controlpanel = controlpanel

----------------------------------------------------------------------------------------
-- Hoteys Help

theme.hotkeys_bg = background_normal
theme.hotkeys_fg = colors.color15 .. "88"
theme.hotkeys_border_width = 0
theme.hotkeys_border_color = background_normal
theme.hotkeys_modifiers_fg = foreground_focus
theme.hotkeys_label_bg = background_normal .. "00"
theme.hotkeys_label_fg = foreground_title
theme.hotkeys_font = "Iosevka Medium " .. font_size(16)
theme.hotkeys_description_font = "Iosevka Medium " .. font_size(14)
theme.hotkeys_group_margin = dpi(50)

----------------------------------------------------------------------------------------
-- Notifications

-- Volume {{{
local nvolume = {icons = {}}

nvolume.icon_size = dpi(25)
nvolume.icon_opacity = 0.8

nvolume.bar = {
    border_radius = dpi(10),
    color = colors.color1,
    background = colors.color7 .. "55",
    height = dpi(300),
    width = dpi(50)
}
nvolume.bar.scale = nvolume.bar.height / 100

nvolume.background = colors.color0 .. "bb"

nvolume.normal_icon = notification_icons .. "volume-normal.png"
nvolume.mute_icon = notification_icons .. "volume-mute.png"

nvolume.animation = {
    show = {
        duration = 0.3,
        easing = "inOutQuart"
    },
    hide = {
        duration = 0.5,
        easing = "inOutQuart"
    }
}
nvolume.show_animation_duration = 1
nvolume.hide_animation_duration = 2

nvolume.border_radius = dpi(0)

nvolume.margin = {
    top = dpi(50),
    right = dpi(50),
    bottom = dpi(50),
    left = dpi(50)
}
nvolume.spacing = dpi(30)

nvolume.width = nvolume.bar.width + nvolume.margin.left + nvolume.margin.right
nvolume.height =
    nvolume.bar.height + nvolume.margin.top + nvolume.margin.bottom + nvolume.icon_size +
    nvolume.spacing

nvolume.x = function(screen)
    return screen.workarea.width - dpi(40) - nvolume.width
end
nvolume.y = function(screen)
    return screen.workarea.height / 2 - nvolume.height / 2
end
-- }}}

-- naughty {{{
local naughty = {}

naughty.font = "IBM Plex Mono Medium " .. font_size(12)

naughty.bg = background_normal
naughty.fg = colors.color15

naughty.bg_critical = background_urgent
naughty.fg_critical = foreground_urgent

-- naughty.width = dpi(..)
-- naughty.height = dpi(..)
naughty.margin = dpi(30)

naughty.opacity = 0.95

naughty.border_width = 0
naughty.border_color = "#18E3C8"
naughty.border_radius = theme.window_border_radius

naughty.padding = dpi(10)
naughty.spacing = dpi(10)

naughty.icon_size = dpi(60)

-- BUG: some notifications appear at top_right regardless
naughty.position = "top_right"
-- }}}

-- Addig widget settings to theme {{{
theme.notifications = {
    volume = nvolume
}
-- }}}

theme.naughty = naughty
----------------------------------------------------------------------------------------

return theme
