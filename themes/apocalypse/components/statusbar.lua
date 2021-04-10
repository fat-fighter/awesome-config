-- =====================================================================================
--   Name:       statusbar.lua
--   Author:     Gurpreet Singh
--   Url:        https://github.com/ffs97/awesome-config/themes/apocalypse/ ...
--               ... components/statusbar.lua
--   License:    The MIT License (MIT)
--
--   Dock to visualize system status and actions
-- =====================================================================================

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful").statusbar

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Defining Helper Functions for Creating Bar

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
-- Defining Function to Create a Bar

local function create_statusbar(screen)
    ----------------------------------------------------------------------------
    -- Creating the StartScreen

    -- In order to remove shadow, the composite manager needs to be configured to ignore
    -- docks in background blurring. For picom, adding "window_type = 'dock" to the
    -- variable blur-background-exclude achieves this result.

    local statusbar =
        awful.wibar {
        visible = true,
        ontop = false,
        position = "top",
        type = "dock",
        height = get_height(screen),
        width = get_width(screen),
        x = get_x(screen),
        y = get_y(screen),
        bg = beautiful.bg
    }

    statusbar:setup {
        helpers.empty_widget,
        require("widgets.statusbar.datetime")(screen),
        helpers.empty_widget,
        layout = wibox.layout.align.horizontal
    }

    ----------------------------------------------------------------------------
    return statusbar
end

-- -------------------------------------------------------------------------------------
return create_statusbar
