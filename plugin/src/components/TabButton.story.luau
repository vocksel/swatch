local React = require("@pkg/React")
local TabButton = require("./TabButton")

return {
	story = function()
		return React.createElement(TabButton, {
			views = { "Home", "History", "Settings", "About" },
			onNavigate = print,
		})
	end,
}
