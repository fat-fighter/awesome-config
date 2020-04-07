----------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local beautiful = require("beautiful")

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers   = require("helpers")

--------------------------------------------------------------------------------
-- Setting Local Variables

local theme_name = "thunderclouds"
local theme_lib  = "themes." .. theme_name .. "."

--------------------------------------------------------------------------------
-- Defining handlers

handlers = {}

-- Screen {{
function handlers.connect_for_each_screen(s)
    s.systray     = require(theme_lib .. "components.systray")(s)
    s.startscreen = require(theme_lib .. "components.startscreen")(s)
end
-- }}

-- Client {{
function handlers.client_connect_focus(c)
    c.border_color = beautiful.window_border_focus
end

function handlers.client_connect_unfocus(c)
    c.border_color = beautiful.window_border_normal
end

function handlers.client_connect_manage(c)
    if not c.fullscreen then
        c.shape = helpers.rrect(beautiful.window_border_radius)
    end
end

function handlers.client_connect_fullscreen(c)
    if c.fullscreen then
        c.shape = helpers.rect()
    else
        c.shape = helpers.rrect(beautiful.window_border_radius)
    end
end
-- }}

--------------------------------------------------------------------------------
return handlers
