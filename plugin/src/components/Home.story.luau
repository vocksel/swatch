local React = require("@pkg/React")
local stories = require("./stories")
local Home = require("./Home")

return {
	story = stories({
		{
			name = "Primary",
			story = function()
				return React.createElement(Home, {
					extensions = {
						{
							extensionName = "theme",
							displayName = "Theme",
							publisher = {
								publisherName = "OnlyTwentyCharacters",
							},
							versions = {
								{
									version = "1.2.3",
								},
							},
						},
					},
					onViewExtension = print,
				})
			end,
		},

		{
			name = "Loading",
			story = function()
				return React.createElement(Home, {
					extensions = {},
					onViewExtension = print,
				})
			end,
		},

		{
			name = "Network error",
			story = function()
				return React.createElement(Home, {
					extensions = {},
					err = "Network error occurred",
					onViewExtension = print,
				})
			end,
		},
	}),
}
