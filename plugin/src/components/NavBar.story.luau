local React = require("@pkg/React")
local NavBar = require("./NavBar")

return {
	story = function()
		return React.createElement(NavBar, {
			views = { "Home", "History", "Settings", "About" },
			onNavigate = print,
		})
	end,
}
