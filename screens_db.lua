local naughty = require("naughty")

local defaultOutput = 'eDP-1-1'

outputMapping = {
    ['DP-0'] = 'DP-0',
    ['DP-1'] = 'DP-1',
    ['HDMI-0'] = 'HDMI-0',
    ['eDP-1-1'] = 'eDP-1-1',
}

screens = {
	['default'] = {
		['connected'] = function (xrandrOutput)
            naughty.notify({text = "Screen Connected"})
            if xrandrOutput ~= defaultOutput then
                return '--output ' .. xrandrOutput .. ' --auto --same-as ' .. defaultOutput
            end
            return nil
		end,
		['disconnected'] = function (xrandrOutput)
            naughty.notify({text = "Screen Disconnected"})
            if xrandrOutput ~= defaultOutput then
                return '--output ' .. xrandrOutput .. ' --off --output ' .. defaultOutput .. ' --auto'
            end
            return nil
		end
	},
}
