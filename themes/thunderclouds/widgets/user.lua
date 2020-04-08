-- -------------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local wibox = require("wibox")
local beautiful = require("beautiful").startscreen.user

-- -------------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

-- -------------------------------------------------------------------------------------
-- Creating the User Widget

-- User picture
local user_picture = wibox.widget {
    image = beautiful.picture,
    resize = true,
    widget = wibox.widget.imagebox
}
user_picture.forced_height = beautiful.picture_height

local user_logo = wibox.container.background()
user_logo.forced_height = beautiful.logo_height

local user_logo_img = wibox.widget {
	image = beautiful.logo,
	resize = true,
	widget = wibox.widget.imagebox
}

user_logo:setup {
	user_logo_img,
	layout = wibox.layout.fixed.vertical
}

-- -------------------------------------------------------------------------------------
-- Creating the Final Widget

local centered = helpers.center_align_widget

local user = wibox.widget {
	centered(user_picture, "horizontal"),
	helpers.vpad(3),
	centered(user_logo, "horizontal"),
	layout = wibox.layout.align.vertical
}

-- -------------------------------------------------------------------------------------
return user
