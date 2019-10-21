--------------------------------------------------------------------------------
-- Including Standard Awesome Libraries

local wibox     = require("wibox")
local gears     = require("gears")
local awful     = require("awful")
local vicious   = require("vicious")
local naughty   = require("components.notify")
local beautiful = require("beautiful").startscreen.battery

--------------------------------------------------------------------------------
-- Including Custom Helper Libraries

local helpers = require("helpers")

--------------------------------------------------------------------------------
-- Defining Function to Create a Workspace Widget

function table_print (tt, indent, done)
	str = ""
	done = done or {}
	indent = indent or 0
	if type(tt) == "table" then
		for key, value in pairs (tt) do
			str = str .. string.rep (" ", indent) -- indent it
			if type (value) == "table" and not done [value] then
				done [value] = true
				str = str .. (string.format("[%s] => table\n", tostring (key)));
				str = str .. (string.rep (" ", indent+4)) -- indent it
				str = str .. ("(\n");
				table_print (value, indent + 7, done)
				str = str .. (string.rep (" ", indent+4)) -- indent it
				str = str .. (")\n");
			else
				str = str .. (string.format("[%s] => %s\n",
				tostring (key), tostring(value)))
			end
		end
	else
		str = str .. (tt .. "\n")
	end

	return str
end

return function(s)
	local tags = awful.tag.gettags(s)
	for i, t in ipairs(tags) do
		require("naughty").notify({text = tostring(i)})
		--awful.tag.seticon("path_to_icon_standard", t)
	end
	--for i = 1, #tags do
	--naughty.notify({text = tostring(i) .. " Tag: " .. tostring(tags[i])})
	--naughty.notify({text = "ASD"})
	--end
	--
	

	return awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
	}
end
