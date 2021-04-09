-- =====================================================================================
--   Name:       tagsbar.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/ ...
--               ... components/tagsbar.lua
--   License:    The MIT License (MIT)
--
--   Widget for custom dashboard
-- =====================================================================================

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful").tagsbar

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Defining Helper Functions for Creating Tags Bar

local function get_width(screen)
    local width = beautiful.width

    if type(width) == "function" then
        width = width(screen)
    end

    screen = screen or awful.screen.focused()
    width = width or screen.workarea.width

    width = width + (beautiful.border.left or 0)
    width = width + (beautiful.border.right or 0)

    return width
end

local function get_height(screen)
    local height = beautiful.height

    if type(height) == "function" then
        height = height(screen)
    end

    screen = screen or awful.screen.focused()
    height = height or screen.workarea.height

    height = height + (beautiful.border.top or 0)
    height = height + (beautiful.border.bottom or 0)

    return height
end

local function get_x(screen, width)
    local x = beautiful.x

    screen = screen or awful.screen.focused()

    if type(x) == "function" then
        x = x(screen)
    else
        x = x or (screen.workarea.width - width) / 2
    end

    return screen.workarea.x + x
end

local function get_y(screen, height)
    local y = beautiful.y

    screen = screen or awful.screen.focused()

    if type(y) == "function" then
        y = y(screen)
    else
        y = y or (screen.workarea.height - height) / 2
    end

    return screen.workarea.y + y
end

-- -------------------------------------------------------------------------------------
-- Defining Function to Create a Tags Bar

local function create_tagsbar(screen)
    ----------------------------------------------------------------------------
    -- Creating the StartScreen

    local taglist =
        awful.widget.taglist {
        screen = screen,
        filter = awful.widget.taglist.filter.all,
        buttons = require("components.keys").taglist_buttons,
        layout = {
            spacing = beautiful.separator.width,
            spacing_widget = {
                color = beautiful.separator.color,
                shape = gears.shape.rectangle,
                widget = wibox.widget.separator
            },
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    helpers.empty_widget,
                    layout = wibox.layout.fixed.horizontal
                },
                top = beautiful.border.top,
                right = beautiful.border.right,
                bottom = beautiful.border.bottom,
                left = beautiful.border.left,
                color = beautiful.border.color,
                widget = wibox.container.margin
            },
            widget = wibox.container.background,
            create_callback = function(self, tag, index, objects) --luacheck: no unused args
                self:connect_signal(
                    "mouse::enter",
                    function()
                        if not self.active then
                            self.backup = self.bg
                            self.bg = beautiful.bg.active
                        end
                        self.active = true
                    end
                )
                self:connect_signal(
                    "mouse::leave",
                    function()
                        if self.active then
                            self.bg = self.backup
                            self.active = false
                        end
                    end
                )
            end,
            update_callback = function(self, tag, index, objects) --luacheck: no unused args
                if tag.selected then
                    self.bg = beautiful.bg.selected
                elseif tag.urgent then
                    self.bg = beautiful.bg.urgent
                elseif #tag:clients() > 0 then
                    self.bg = beautiful.bg.occupied
                else
                    self.bg = beautiful.bg.empty
                end
                self.backup = self.bg
            end
        }
    }

    local ba = beautiful.border.rounding
    local tagsbar =
        wibox {
        visible = true,
        ontop = false,
        type = "dock",
        bg = beautiful.bar_bg,
        shape = helpers.prrect(beautiful.border.radius, ba.tl, ba.tr, ba.br, ba.bl)
    }

    tagsbar:setup {
        widget = taglist
    }

    tagsbar.x = get_x(screen)
    tagsbar.y = get_y(screen)

    tagsbar.width = get_width(screen)
    tagsbar.height = get_height(screen)

    ----------------------------------------------------------------------------
    return tagsbar
end

-- -------------------------------------------------------------------------------------
return create_tagsbar
