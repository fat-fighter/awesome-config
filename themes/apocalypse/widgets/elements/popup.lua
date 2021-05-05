-- =====================================================================================
--   Name:       popup.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/themes/apocalypse/widgets/elements ...
--               ... popup.lua
--   License:    The MIT License (MIT)
--
--   Element popup for apocalypse theme widgets
-- =====================================================================================

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the Popup Destroyer

awful.screen.connect_for_each_screen(
    function(s)
        s.popups = {}
        function s:destroy_popups()
            for popup, _ in pairs(self.popups) do
                popup.visible = false
            end
            self.popup_destroyer.visible = false
        end

        s.popup_destroyer =
            wibox {
            opacity = 0,
            visible = false,
            ontop = true,
            type = "dock",
            height = s.geometry.height,
            width = s.geometry.width,
            x = s.workarea.x,
            y = s.workarea.y
        }

        s.popup_destroyer:buttons(
            gears.table.join(
                awful.button(
                    {},
                    1,
                    function()
                        s:destroy_popups()
                    end
                )
            )
        )
    end
)

-- -------------------------------------------------------------------------------------
-- Creating the Popup Element Wrapper

local function popup(widget, controller, config)
    if not config then
        config = {}
    end

    local popup_widget =
        wibox {
        visible = false,
        ontop = true,
        bg = config.bg,
        width = config.width,
        height = config.height,
        border_width = (config.border or {}).width,
        border_color = (config.border or {}).color,
        shape = helpers.rrect((config.border or {radius = 0}).radius)
    }
    popup_widget:setup {
        widget,
        layout = wibox.layout.fixed.vertical
    }

    config.placement = config.placement or "center"

    controller:buttons(
        gears.table.join(
            awful.button(
                {},
                1,
                function()
                    local screen = awful.screen.focused({client = false, mouse = true})

                    if not popup_widget.visible then
                        local g = mouse.current_widget_geometry

                        popup_widget.y = g.y + g.height + (config.spacing or 0)

                        if config.placement == "center" then
                            popup_widget.x = g.x + (g.width - (config.width or 0)) // 2
                        elseif config.placement == "left" then
                            popup_widget.x = g.x + g.width - (config.width or 0)
                        elseif config.placement == "right" then
                            popup_widget.x = g.x
                        end
                        popup_widget.x =
                            math.min(
                            popup_widget.x,
                            screen.geometry.x + screen.geometry.width - config.width -
                                config.spacing
                        )

                        screen.popups[popup_widget] = true
                        screen.popup_destroyer.visible = true

                        popup_widget.visible = true
                    else
                        popup_widget.visible = false
                        screen.popups[popup_widget] = nil

                        if #(screen.popups) == 0 then
                            screen.popup_destroyer.visible = false
                        end
                    end
                end
            )
        )
    )

    return popup_widget
end

-- -------------------------------------------------------------------------------------
return popup
