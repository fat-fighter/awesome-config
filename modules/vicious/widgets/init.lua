
local wrequire = require("modules.vicious.helpers").wrequire
widgets = { _NAME = "vicious.widgets" }

return setmetatable(widgets, {__index = wrequire})
