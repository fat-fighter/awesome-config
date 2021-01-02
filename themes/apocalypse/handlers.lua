-- =====================================================================================
--   Name:       handlers.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/thunderclouds/ ...
--               ... handlers.lua
--   License:    The MIT License (MIT)
--
--   Theme specific connect handlers for clients and tags
-- =====================================================================================

local beautiful = require("beautiful")

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

--------------------------------------------------------------------------------
-- Defining handlers

handlers = {}

st = require("components.systray")

-- Screen {{{
function handlers.connect_for_each_screen(s)
    s.mytaglist = require("components.bar")(s)
    s.systray = st
    s.controlpanel = require("components.controlpanel")(s)
    s.notifs = {
        volume = require("notifs.volume"),
        brightness = require("notifs.brightness")
    }
end
-- }}}

-- Client {{{
function handlers.client_connect_focus(c)
    c.border_color = beautiful.window_border_focus
end

function handlers.client_connect_unfocus(c)
    c.border_color = beautiful.window_border_normal
end

function handlers.client_connect_manage(c)
    -- Add shape to client

    if not c.fullscreen then
        c.shape = helpers.rrect(beautiful.window_border_radius)
    end
end

function handlers.client_connect_fullscreen(c)
    -- Remove shapes in fullscreen mode

    if c.fullscreen then
        c.shape = helpers.rect()
    else
        c.shape = helpers.rrect(beautiful.window_border_radius)
    end
end
-- }}}

--------------------------------------------------------------------------------
return handlers
