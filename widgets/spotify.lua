--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local awful     = require("awful")
local gears     = require("gears")
local wibox     = require("wibox")
local beautiful = require("beautiful").startscreen.spotify

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

--------------------------------------------------------------------------------
-- Creating Information Textboxes and Imageboxes

local title_text = wibox.widget{
	text          = "---------",
	font          = beautiful.font.title,
	valign        = "center",
	forced_height = 22,
	widget        = wibox.widget.textbox,
}
local title_container = wibox.widget {
	title_text,
	layout        = wibox.container.scroll.horizontal,
	step_function = wibox.container.scroll.step_functions.linear_increase,
	extra_space   = beautiful.scroll_space,
   	speed         = beautiful.scroll_speed
}

local artist_text = wibox.widget{
	text          = "---------",
	font          = beautiful.font.artist,
	valign        = "center",
	forced_height = 22,
	widget        = wibox.widget.textbox
}
local artist_container = wibox.widget {
	artist_text,
	layout        = wibox.container.scroll.horizontal,
	step_function = wibox.container.scroll.step_functions.linear_increase,
	extra_space   = beautiful.scroll_space,
   	speed         = beautiful.scroll_speed
}

local album_art        = wibox.widget {
	resize        = true,
	opacity       = 0.75,
	clip_shape    = helpers.rrect(beautiful.art_border_radius),
	forced_width  = beautiful.art_size,
	forced_height = beautiful.art_size,
	widget        = wibox.widget.imagebox
}

--------------------------------------------------------------------------------
-- Creating Control Buttons

local prev_button = wibox.widget.imagebox(beautiful.icons.prev)
prev_button.forced_height = beautiful.icons.size

local next_button = wibox.widget.imagebox(beautiful.icons.next)
next_button.forced_height = beautiful.icons.size

local toggle_button = wibox.widget.imagebox(beautiful.icons.play)
toggle_button.forced_height = beautiful.icons.size

prev_button:buttons(gears.table.join(
	awful.button({ }, 1, function ()
		awful.spawn.with_shell("sp prev")
	end)
))
toggle_button:buttons(gears.table.join(
	awful.button({ }, 1, function ()
		awful.spawn.with_shell("sp play")
	end)
))
next_button:buttons(gears.table.join(
	awful.button({ }, 1, function ()
		awful.spawn.with_shell("sp next")
	end)
))

--------------------------------------------------------------------------------
-- Creating the Widget

local centered = helpers.center_align_widget
local spotify = wibox.widget {
	{
		{
			album_art,
			helpers.hpad(3),
			{
				nil,
				nil,
				{
					title_container,
					helpers.vpad(0.2),
					artist_container,
					layout = wibox.layout.fixed.vertical
				},
				layout = wibox.layout.align.vertical
			},
			layout = wibox.layout.fixed.horizontal
		},
		helpers.vpad(1.5),
		centered(
			{
				prev_button, toggle_button, next_button,
				spacing = beautiful.icons.margin,
				layout = wibox.layout.flex.horizontal
			}, "horizontal"
		),
		layout = wibox.layout.fixed.vertical
	},
	left   = beautiful.margin,
	right  = beautiful.margin,
	widget = wibox.container.margin
}

spotify.current_track_url = nil

--------------------------------------------------------------------------------
-- Subscribing to Spotify Changes

local art_update_script = [[
	track=`playerctl metadata mpris:artUrl | cut -f5 -d"/"`
	if ]] .. "[[ ! -f " .. beautiful.art_dir .. "$track.jpg ]]" .. [[ ; then
		wget https://open.spotify.com/image/$track -O ]] .. beautiful.art_dir .. [[$track.jpg
	fi
	echo $track
]]

local current_track = nil

local function update_widget(line)
	local status = line:match("^[^|]+"):lower()
	line = line:sub(#status + 2)

	
	if status == "playing" then
		toggle_button.image = beautiful.icons.pause
	else
		toggle_button.image = beautiful.icons.play
	end

	local at, tt
	local ac, tc
	
	if status ~= "stopped" then
		local artist = line:match("^[^|]+")
		line = line:sub(#artist + 2)

		local title = line:match("^[^|]+")
		line = line:sub(#title + 2)

		local album = line:match("^[^|]+$")
		
		 --Escape &'s
		artist = artist:gsub("&", "&amp;")
		title  = title:gsub("&", "&amp;")
		album  = album:gsub("&", "&amp;")

		-- Set text and colours
		at = artist .. " -- " .. album
		tt = title
		
		ac = beautiful.fg.artist[status] or "#FDFDFD"
		tc = beautiful.fg.title[status] or "#FDFDFD"

		awful.spawn.easy_async_with_shell(
			art_update_script,
			function (track)
				track = track:sub(1, -2)
				if track ~= current_track then
					current_track = track
					album_art.image = beautiful.art_dir .. track .. ".jpg"
				end
			end
		)
	else
		at = "----------"
		tt = "----------"
		
		ac = beautiful.fg.artist[status] or "#777777"
		tc = beautiful.fg.title[status] or "#777777"
	end

	artist_text.markup = helpers.colorize_text(at, ac)
	title_text.markup  = helpers.colorize_text(tt, tc)
end

-- Sleeps until spotify changes state
local spotify_script = [[
	bash -c "
		sp subscribe
	"
]]

awful.spawn.with_line_callback(spotify_script, {
	stdout = function(line)
		update_widget(line)
	end
})

--------------------------------------------------------------------------------
return spotify
