local React = require("@pkg/React")
local ThemeLabel = require("./ThemeLabel")
local themesSnapshot = require("@root/requests/snapshots/get-v1-themes")

return {
	story = function()
		return React.createElement(ThemeLabel, {
			theme = themesSnapshot[1],
			onApplyTheme = function()
				print("apply theme")
			end,
		})
	end,
}
