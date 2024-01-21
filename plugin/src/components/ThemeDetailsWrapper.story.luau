local React = require("@pkg/React")
local ThemeDetailsWrapper = require("./ThemeDetailsWrapper")

return {
	story = function()
		return React.createElement(ThemeDetailsWrapper, {
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
			},
			onBack = function()
				print("go back")
			end,
		})
	end,
}
