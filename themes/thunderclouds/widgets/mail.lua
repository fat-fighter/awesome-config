-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful").startscreen.mail

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the Mail Widget

local mail_icon = wibox.widget {
	image = beautiful.icon,
	resize = true,
	forced_width = beautiful.icon_size,
	forced_height = beautiful.icon_size,
	widget = wibox.widget.imagebox
}

local centered = helpers.center_align_widget

local mail_text = wibox.widget {
	font = beautiful.font,
	align = "center",
	valign = "center",
	markup = "",
	widget = wibox.widget.textbox
}
local mail_textbox = wibox.widget {
	centered(
		centered(mail_text, "horizontal"),
		"vertical"
	),
	bg = beautiful.bg_notification,
	shape = gears.shape.circle,
	visible = false,
	forced_width = beautiful.notification_size,
	forced_height = beautiful.notification_size,
	widget = wibox.container.background
}

local mail = wibox.widget {
	bg = beautiful.bg,
	shape = helpers.rrect(beautiful.border_radius or 0),
	forced_width = beautiful.width,
	forced_height = beautiful.height,
	widget = wibox.container.background
}
mail:setup {
	centered(
		centered(mail_icon, "horizontal"),
		"vertical"
	),
	{
		mail_textbox,
		top = (
			beautiful.width - beautiful.icon_size - beautiful.notification_size
		) / 2 - beautiful.notification_shift,
		left = (
			beautiful.width + beautiful.icon_size - beautiful.notification_size
		) / 2 + beautiful.notification_shift,
		right = (
			beautiful.width - beautiful.icon_size - beautiful.notification_size
		) / 2 - beautiful.notification_shift,
		bottom = (
			beautiful.width + beautiful.icon_size - beautiful.notification_size
		) / 2 + beautiful.notification_shift,
		layout = wibox.container.margin
	},
	layout = wibox.layout.stack
}

helpers.add_clickable_effect(
	mail,
	function()
		mail.bg = beautiful.bg_hover
	end,
	function()
		mail.bg = beautiful.bg
	end
)


-- -------------------------------------------------------------------------------------
-- Adding Update Function

local feed = "https://mail.google.com/mail/feed/atom/^sq_ig_i_personal"
local mail_script = "curl --connect-timeout 1 -m 3 -fsn '" .. feed .. "' | head -c 2000"

local function update_widget()
	awful.spawn.easy_async_with_shell(
		mail_script,
		function(stdout)
			local count = tonumber(
                string.match(stdout, "<fullcount>([%d]+)</fullcount>")
            ) or 0

			if count == 0 then
				mail_textbox.visible = false
			else
				if count > 9 then
					count = "+"
				end
				mail_textbox.visible = true
			end
			
			mail_text.markup = helpers.colorize_text(tostring(count), beautiful.fg)
		end
	)
end

local timer = gears.timer {
    timeout = 120,
	call_now = true,
    autostart = true,
    callback = update_widget
}

-- -------------------------------------------------------------------------------------
-- Adding Button Controls to the Widget

mail:buttons(gears.table.join(
	-- Left click - Open google mail
	awful.button({}, 1, function()
		awful.spawn.with_shell("xdg-open 'https://mail.google.com'")
	end)
))

-- -------------------------------------------------------------------------------------
return mail
