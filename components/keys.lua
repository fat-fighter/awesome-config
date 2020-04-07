--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local join      = require("gears").table.join
local awful     = require("awful")
local wibox     = require("wibox")
local naughty   = require("naughty")
local beautiful = require("beautiful")

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers     = require("helpers")
local systray     = require("components.systray")

--------------------------------------------------------------------------------
-- Setting Mod Keys

superkey = "Mod4" -- Windows key

altkey   = "Mod1"
ctrlkey  = "Control"
shiftkey = "Shift"

--------------------------------------------------------------------------------
-- Defining Local Variables


local keys = {
    clientkeys     = {},
    globalkeys     = {},
    clientbuttons  = {},
    desktopbuttons = {}
}

local screen_width  = function()
	return awful.screen.focused().geometry.width
end

local screen_height = function()
	return awful.screen.focused().geometry.height
end

--------------------------------------------------------------------------------
-- Adding Desktop Buttons

keys.desktopbuttons = join(
    -- Left click
    awful.button({ }, 1, function()
        awful.screen.focused().startscreen:hide()
        naughty.destroy_all_notifications()
    end),

    -- Middle button
    awful.button({ }, 2, function()
        awful.screen.focused().startscreen:toggle()
    end),

    -- Scrolling - Switch tags
    --awful.button({ }, 4, awful.tag.viewnext),
    --awful.button({ }, 5, awful.tag.viewprev),

    -- Side buttons - Control volume
    -- awful.button({ }, 9, function() awful.spawn.with_shell("volume set +5") end),
    -- awful.button({ }, 8, function() awful.spawn.with_shell("volume set -5") end),

    -- Side buttons - Minimize and restore minimized client
    -- awful.button({ }, 8, function()
    --     if client.focus ~= nil then
    --         client.focus.minimized = true
    --     end
    -- end),
    -- awful.button({ }, 9, function()
    --       local c = awful.client.restore()
    --       -- Focus restored client
    --       if c then
    --           client.focus = c
    --           c:raise()
    --       end
    -- end)

    keys.desktopbuttons
)

--------------------------------------------------------------------------------
-- Adding Client Window Management Keys

-- Focus
keys.globalkeys = join(
    -- Focus client by direction
    awful.key(
        { superkey }, "Down",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }
    ),

    awful.key(
        { superkey }, "Up",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client" }
    ),

    awful.key(
        { superkey }, "Left",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client" }
    ),

    awful.key(
        { superkey }, "Right",
        function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client" }
    ),

    -- Focus client by index (cycle through clients)
    awful.key(
        { superkey }, "j",
        function()
            awful.client.focus.byidx( 1)
        end,
        { description = "focus next by index", group = "client" }
    ),

    awful.key(
        { superkey }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),

    awful.key(
        { altkey }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }
    ),

    keys.globalkeys
)

-- Layout
keys.globalkeys = join(
    awful.key(
        -- Swap clients by direction
        { superkey, shiftkey }, "Down",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            
            if c ~= nil and (current_layout == "floating" or c.floating) then
                helpers.move_client_to_edge(c, "down")
            else
                awful.client.swap.bydirection("down", c, nil)
            end
        end,
        { description = "swap with direction down", group = "client" }
    ),

    awful.key(
        { superkey, shiftkey }, "Up",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            
            if c ~= nil and (current_layout == "floating" or c.floating) then
                helpers.move_client_to_edge(c, "up")
            else
                awful.client.swap.bydirection("up", c, nil)
            end
        end,
        { description = "swap with direction up", group = "client" }
    ),

    awful.key(
        { superkey, shiftkey }, "Left",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            
            if c ~= nil and (current_layout == "floating" or c.floating) then
                helpers.move_client_to_edge(c, "left")
            else
                awful.client.swap.bydirection("left", c, nil)
            end
        end,
        { description = "swap with direction left", group = "client" }
    ),

    awful.key(
        { superkey, shiftkey }, "Right",
        function()
            local current_layout = awful.layout.getname(awful.layout.get(awful.screen.focused()))
            local c = client.focus
            
            if c ~= nil and (current_layout == "floating" or c.floating) then
                helpers.move_client_to_edge(c, "right")
            else
                awful.client.swap.bydirection("right", c, nil)
            end
        end,
        { description = "swap with direction right", group = "client" }
    ),

    keys.globalkeys
)

-- Minimize and maximize
keys.globalkeys = join(
    -- Restore last minimized client
    awful.key(
        { superkey, shiftkey }, "n",
        function()
            local c = awful.client.restore()
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "restore minimized", group = "client" }
    ),

    keys.globalkeys
)

keys.clientkeys = join(
    -- Minimize
    awful.key(
        { superkey }, "n",
        function(c)
            c.minimized = true
        end,
        { description = "minimize", group = "client" }
    ),

    -- Maximize and unmaximize (horizontal, vertical, or both)
    awful.key(
        { superkey }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }
    ),

    awful.key(
        { superkey, ctrlkey }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }
    ),

    awful.key(
        { superkey, shiftkey }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" }
    ),

    awful.key(
        { superkey }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }
    ),

    keys.clientkeys
)

-- Titlebars
keys.clientkeys = join(
    awful.key(
        { superkey }, "v",
        function(c)
            if not beautiful.titlebars_imitate_borders then
                awful.titlebar.toggle(c, beautiful.titlebar_position)
            end
        end,
        { description = "toggle titlebar", group = "client" }
    ),
    
    awful.key(
        { superkey, shiftkey }, "v",
        function(c)
            local clients = awful.screen.focused().clients
            for _, c in pairs(clients) do
                if not beautiful.titlebars_imitate_borders then
                    awful.titlebar.toggle(c, beautiful.titlebar_position)
                end
            end
        end,
        { description = "toggle titlebar for all clients", group = "client" }
    ),

    keys.clientkeys
)

-- Floating
keys.clientkeys = join(
    -- Toggle floating
	awful.key(
        { superkey, ctrlkey }, "space",
	    function(c)
            local current_layout = awful.layout.getname(
                awful.layout.get(awful.screen.focused())
            )
            if current_layout ~= "floating" then
                awful.client.floating.toggle()
            end
            c:raise()
        end,
	    { description = "toggle floating", group = "client" }
    ),

    -- Set window to floating and change size
    awful.key(
        { superkey, ctrlkey }, "f",
        function(c)
            c.floating = true
            c.width = screen_width() * 0.7
            c.height = screen_height() * 0.75
            
            awful.placement.centered(c, { honor_workarea=true })

            c:raise()
        end,
        { description = "focus floating mode", group = "client" }
    ),

    awful.key(
        { superkey, ctrlkey }, "t",
        function(c)
            c.floating = true
            c.width = screen_width() * 0.3
            c.height = screen_height() * 0.35
            
            awful.placement.centered(c, { honor_workarea=true })

            c:raise()
        end,
        { description = "tiny floating mode", group = "client" }
    ),

    awful.key(
        { superkey, ctrlkey }, "v",
        function(c)
            c.floating = true
            c.width = screen_width() * 0.45
            c.height = screen_height() * 0.85
            
            awful.placement.centered(c, { honor_workarea=true })

            c:raise()
        end,
        { description = "vertical floating mode", group = "client" }
    ),

    awful.key(
        { superkey, ctrlkey }, "n",
        function(c)
            c.floating = true
            c.width = screen_width() * 0.45
            c.height = screen_height() * 0.5
            
            awful.placement.centered(c, { honor_workarea=true })

            c:raise()
        end,
        { description = "normal floating mode", group = "client" }
    ),

    keys.clientkeys
)

-- Client properties
keys.clientkeys = join(
    -- On top
    awful.key(
        { superkey, shiftkey }, "o",
        function (c)
            c.ontop = not c.ontop
        end,
        { description = "toggle keep on top", group = "client" }
    ),

    -- Sticky
    awful.key(
        { superkey, shiftkey }, "s",
        function (c)
            c.sticky = not c.sticky
        end,
        { description = "toggle sticky", group = "client" }
    ),

    keys.clientkeys
)

-- Mouse events
keys.clientbuttons = join(
    -- Left button - Focus
    awful.button(
        {}, 1,
        function(c)
            client.focus = c
            c:raise()
        end
    ),
    
    -- modkey + Left button - Focus
    awful.button(
        { superkey }, 1,
        awful.mouse.client.move
    ),

    keys.clientbuttons
)

-- Urgent
keys.globalkeys = join(
	awful.key(
        { superkey }, "u",
        function()
            uc = awful.client.urgent.get()
            if uc ~= nil then
                awful.client.urgent.jumpto()
            end
        end,
        { description = "jump to urgent client", group = "client" }
    ),

    keys.globalkeys
)

-- Quit
keys.clientkeys = join(
    awful.key(
        { superkey }, "q",
        function(c)
            c:kill()
        end,
        { description = "close", group = "client" }
    ),

    keys.clientkeys
)

--------------------------------------------------------------------------------
-- Adding Layout Management Keys

-- Layout
keys.globalkeys = join(
    -- Change layout of current workspace
    awful.key(
        { superkey, altkey }, "space",
        function()
            awful.layout.inc(1)
        end,
        { description = "select next layout", group = "layout" }
    ),

    awful.key(
        { superkey, altkey, shiftkey }, "space",
        function()
            awful.layout.inc(-1)
        end,
        { description = "select previous layout", group = "layout" }
    ),
    
    -- Max layout
    awful.key(
        { superkey }, "w",
        function()
            awful.layout.set(awful.layout.suit.max)
        end,
        { description = "set max layout", group = "layout" }
    ),
    
    -- Spiral dwindle layout
    awful.key(
        { superkey }, "d",
        function()
            awful.layout.set(awful.layout.suit.spiral.dwindle)
        end,
        { description = "set spiral dwindle layout", group = "layout" }
    ),
    
    -- Floating layout
    awful.key(
        { superkey }, "a",
        function()
            awful.layout.set(awful.layout.suit.fair)
        end,
        { description = "set fair layout", group = "layout" }
    ),
    
    -- Max layout
    awful.key(
        { superkey }, "s",
        function()
            awful.layout.set(awful.layout.suit.floating)
        end,
        { description = "set floating layout", group = "layout" }
    ),

    keys.globalkeys
)

-- Master width factor
keys.globalkeys = join(
    awful.key(
        { superkey, ctrlkey }, "minus",
        function()
            local current_layout = awful.layout.getname(
                awful.layout.get(awful.screen.focused())
            )
            local c = client.focus
            
            if current_layout == "floating" or (c ~= nil and c.floating == true) then
                c:relative_move(0, 0, -20, 0)
            else
                awful.tag.incmwfact(-0.05)
            end
        end,
        { description = "decrease master width factor", group = "layout" }
    ),

    awful.key(
        { superkey, ctrlkey }, "equal",
        function()
            local current_layout = awful.layout.getname(
                awful.layout.get(awful.screen.focused())
            )
            local c = client.focus

            if current_layout == "floating" or (c ~= nil and c.floating == true) then
                c:relative_move(0, 0, 20, 0)
            else
                awful.tag.incmwfact(0.05)
            end
        end,
        { description = "increase master width factor", group = "layout" }
    ),

    keys.globalkeys
)

-- Layou of master clients
keys.globalkeys = join(
    -- Number of master clients
	awful.key(
        { superkey, shiftkey }, "equal",
        function() 
            awful.tag.incnmaster( 1, nil, true) 
        end,
        { description = "increase the number of master clients", group = "layout" }
    ),

	awful.key(
        { superkey, shiftkey }, "minus",
        function () 
            awful.tag.incnmaster(-1, nil, true)
        end,
        { description = "increase the number of master clients", group = "layout" }
    ),

    -- Number of non-master columns
	awful.key(
        { superkey, ctrlkey, shiftkey }, "equal",
        function() 
            awful.tag.incncol( 1, nil, true)
        end,
        { description = "increase the number of non-master columns", group = "layout" }
    ),

	awful.key(
        { superkey, ctrlkey, shiftkey }, "minus",
        function () 
            awful.tag.incncol(-1, nil, true)
        end,
        { description = "increase the number of non-master columns", group = "layout" }
    ),

    keys.globalkeys
)

--------------------------------------------------------------------------------
-- Adding Awesome Shortcut Keys

keys.globalkeys = join(
    -- Reload awesome config
    awful.key(
        { superkey, shiftkey }, "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),

    -- Toggle startscreen
    awful.key(
        { superkey }, "grave",
        function()
            awful.screen.focused().startscreen:toggle()
        end,
        { description = "toggle startscreen", group = "awesome" }
    ),

    -- Toggle system tray
    awful.key(
        { superkey }, "equal",
        function()
            systray.visible = not systray.visible
        end,
        { description = "toggle tray visibility", group = "awesome" }
    ),

    -- Dismiss notifications
    awful.key(
        { ctrlkey }, "space",
        function()
            naughty.destroy_all_notifications()
        end,
        { description = "dismiss notification", group = "notifications" }
    ),

    -- Volume control
    awful.key(
        {}, "XF86AudioMute",
        function()
            awful.spawn.with_shell("volume mute")
        end,
        { description = "(un)mute volume", group = "volume" }
    ),

    awful.key(
        {}, "XF86AudioRaiseVolume",
        function()
            awful.spawn.with_shell("volume set +1")
        end,
        { description = "raise volume", group = "volume" }
    ),

    awful.key(
        {}, "XF86AudioLowerVolume",
        function()
            awful.spawn.with_shell("volume set -1")
        end,
        { description = "lower volume", group = "volume" }
    ),

    -- Brightness control
    awful.key(
        {}, "XF86MonBrightnessUp",
        function()
            awful.spawn.with_shell("light -A 3")
        end,
        { description = "increase brightness", group = "brightness" }
    ),

    awful.key(
        {}, "XF86MonBrightnessDown",
        function()
            awful.spawn.with_shell("light -U 3")
        end,
        { description = "decrease brighness", group = "brightness" }
    ),

    -- Screenshots
    awful.key(
        {}, "Print",
        function()
            awful.spawn.with_shell(
                "gnome-screenshot -a -f ~/downloads/screenshot.png"
            )
        end,
        { description = "select area to capture screenshot", group = "screenshots" }
    ),

    awful.key(
        { superkey }, "Print",
        function()
            awful.spawn.with_shell(
                "gnome-screenshot -w -f ~/downloads/screenshot.png"
            )
        end,
        { description = "capture whole screen", group = "screenshots" }
    ),

    -- Media control
    awful.key(
        { superkey }, "period",
        function()
			awful.spawn.with_shell("playerctl next")
        end,
        { description = "next", group = "media" }
    ),

    awful.key(
        { superkey }, "comma",
        function()
			awful.spawn.with_shell("playerctl previous")
        end,
        { description = "prev", group = "media" }
    ),

    awful.key(
        { superkey }, "space",
        function()
			awful.spawn.with_shell("playerctl play-pause")
        end,
        { description = "toggle", group = "media" }
    ),

    awful.key(
        {}, "XF86AudioPlay",
        function()
			awful.spawn.with_shell("playerctl play-pause")
        end,
        { description = "toggle", group = "media" }
    ),

    awful.key(
        {}, "XF86AudioPrev",
        function()
			awful.spawn.with_shell("playerctl previous")
        end,
        { description = "prev", group = "media" }
    ),

    awful.key(
        {}, "XF86AudioNext",
        function()
			awful.spawn.with_shell("playerctl next")
        end,
        { description = "next", group = "media" }
    ),

    keys.globalkeys
)

--------------------------------------------------------------------------------
-- Adding Program Shortcut Keys

keys.globalkeys = join(
    -- Terminal
    awful.key(
        { superkey }, "t", function()
            awful.spawn(terminal)
        end,
        { description = "spawn terminal", group = "launcher" }
    ),

    awful.key(
        { superkey, shiftkey }, "t",
        function()
            awful.spawn(terminal, { floating = true })
        end,
        { description = "spawn floating terminal", group = "launcher" }
    ),

    -- Rofi
    awful.key(
        { superkey }, "Return",
        function()
            awful.spawn.with_shell("rofi -show combi -theme fatmenu")
        end,
        { description = "spawn rofi", group = "launcher" }
    ),

    -- Ranger
    awful.key(
        { superkey }, "F1",
        function()
            awful.spawn(terminal .. " -e ranger")
        end,
        { description = "spawn ranger", group = "launcher" }
    ),

    -- Cava
    awful.key(
        { superkey }, "F2",
        function()
            awful.spawn(terminal .. " -e cava")
        end,
        { description = "spawn cava", group = "launcher" }
    ),

    -- Editor
    awful.key(
        { superkey }, "e",
        function()
            awful.spawn(editor)
        end,
        { description = "spawn editor", group = "launcher" }
    ),

    awful.key(
        { superkey }, "i", 
        function()
            require("awful.hotkeys_popup").show_help()
        end,
        {description="show help", group="awesome"}
    ),

    keys.globalkeys
)

--------------------------------------------------------------------------------
-- Adding Workspace + Client Control Keys

-- Moving
keys.globalkeys = join(
	awful.key(
        { superkey, ctrlkey }, "Left",
        awful.tag.viewprev,
	    { description = "view previous", group = "tag" }
    ),

	awful.key(
        { superkey, ctrlkey }, "Right",
        awful.tag.viewnext,
	    { description = "view next", group = "tag" }
    ),

    keys.globalkeys
)

-- Clients + workspaces
for i = 1, ntags do
    keys.globalkeys = join(
        -- View tag
        awful.key(
            { superkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                local current_tag = screen.selected_tag
                
                if tag then
                    if tag == current_tag then
                        awful.tag.history.restore()
                    else
                        tag:view_only()
                    end
                end
            end,
            { description = "view tag #" .. i, group = "tag" }
        ),

        -- Toggle tag display
        awful.key(
            { superkey, ctrlkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }
        ),

        -- Move client to tag
        awful.key(
            { superkey, shiftkey }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #"..i, group = "tag" }
        ),

        -- Toggle client on tag
        awful.key(
            { superkey, ctrlkey, shiftkey }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" }
        ),

        keys.globalkeys
    )
end

for i = 1, ntags / 2 do
    keys.globalkeys = join(
        -- View tag
        awful.key(
            { superkey, altkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[ntags / 2 + i]
                local current_tag = screen.selected_tag
                
                if tag then
                    if tag == current_tag then
                        awful.tag.history.restore()
                    else
                        tag:view_only()
                    end
                end
            end,
            { description = "view tag #" .. i, group = "tag" }
        ),

        -- Toggle tag display
        awful.key(
            { superkey, ctrlkey, altkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[ntags / 2 + i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }
        ),

        -- Move client to tag
        awful.key(
            { superkey, shiftkey, altkey }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[ntags / 2 + i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #"..i, group = "tag" }
        ),

        -- Toggle client on tag
        awful.key(
            { superkey, ctrlkey, shiftkey, altkey }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[ntags / 2 + i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" }
        ),

        keys.globalkeys
    )
end

--------------------------------------------------------------------------------
-- Set Keys and Buttons

root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

--------------------------------------------------------------------------------
return keys
