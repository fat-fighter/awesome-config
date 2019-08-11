--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local naughty   = require("naughty")
local beautiful = require("beautiful").naughty

--------------------------------------------------------------------------------
-- Changing Naughty Configuration

naughty.config.defaults["icon_size"] = beautiful.icon_size

-- Timeouts
naughty.config.defaults.timeout         = 5
naughty.config.presets.low.timeout      = 2
naughty.config.presets.critical.timeout = 50

-- Apply theme variables
naughty.config.padding                = beautiful.padding or 0
naughty.config.spacing                = beautiful.spacing or 0

naughty.config.defaults.font          = beautiful.font or "monospace 11"
naughty.config.defaults.margin        = beautiful.margin or 0
naughty.config.defaults.position      = beautiful.position or "top-right"
naughty.config.defaults.border_width  = beautiful.border_width or 0

-- Adding presets
naughty.config.presets.normal   = {
	fg            = beautiful.fg or "#FDFDFD",
	bg            = beautiful.bg or "#333333",
	border_radius = beautiful.border_radius or 0
}

naughty.config.presets.low      = {
	fg            = beautiful.fg or "#FDFDFD",
	bg            = beautiful.bg or "#333333",
	border_radius = beautiful.border_radius or 0
}

naughty.config.presets.ok       = naughty.config.presets.low
naughty.config.presets.info     = naughty.config.presets.low
naughty.config.presets.warn     = naughty.config.presets.normal

naughty.config.presets.critical = {
	fg            = beautiful.fg_critical or "#333333",
	bg            = beautiful.bg_critical or "#FF3D3D",
	border_radius = beautiful.border_radius or 0
}

--------------------------------------------------------------------------------
return naughty
