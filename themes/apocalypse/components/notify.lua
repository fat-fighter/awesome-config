-- =====================================================================================
--   Name:       notify.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/ ...
--               ... components/notify.lua
--   License:    The MIT License (MIT)
--
--   Theme specific custom configuration for naughty notifications
-- =====================================================================================

local theme = require("beautiful")
local naughty = require("naughty")
local beautiful = theme.naughty

-- -------------------------------------------------------------------------------------
-- Changing Naughty Configuration

naughty.config.defaults["icon_size"] = beautiful.icon_size

-- Timeouts {{{
naughty.config.defaults.timeout = 5
naughty.config.presets.low.timeout = 2
naughty.config.presets.critical.timeout = 50
-- }}}

-- Apply theme variables {{{
naughty.config.padding = beautiful.padding or 0
naughty.config.spacing = beautiful.spacing or 0

naughty.config.defaults.font = beautiful.font or "monospace 11"
naughty.config.defaults.margin = beautiful.margin or 0
naughty.config.defaults.position = beautiful.position or "top-right"
naughty.config.defaults.border_width = beautiful.border_width or 0
-- }}}

-- Adding presets {{{
naughty.config.presets.normal = {
	fg = beautiful.fg,
	bg = beautiful.bg
}

naughty.config.presets.low = {
	fg = beautiful.fg,
	bg = beautiful.bg
}

naughty.config.presets.ok = naughty.config.presets.low
naughty.config.presets.info = naughty.config.presets.low
naughty.config.presets.warn = naughty.config.presets.normal

naughty.config.presets.critical = {
	fg = beautiful.fg_critical,
	bg = beautiful.bg_critical
}
-- }}}

-- Applying border radius {{{
theme.notification_shape = function(cr, width, height)
	require("gears").shape.rounded_rect(cr, width, height, theme.window_border_radius)
end
-- }}}

-- -------------------------------------------------------------------------------------
return naughty
