local React = require("@pkg/React")
local ThemeDetails = require("./ThemeDetails")
local themesSnapshot = require("@root/requests/snapshots/get-v1-themes")

return {
	story = function()
		return React.createElement(ThemeDetails, {
			extension = {
				extensionName = "theme-monokai-pro-vscode",
				displayName = "Monokai Pro",
				publisher = {
					publisherName = "monokai",
				},
				versions = {
					{
						version = "1.2.2",
					},
				},
			} :: any,
			themes = themesSnapshot,
			onBack = function()
				print("go back")
			end,
		})
	end,
}
