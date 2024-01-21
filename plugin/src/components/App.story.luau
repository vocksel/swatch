local React = require("@pkg/React")
local App = require("./App")

return {
	story = function()
		return React.createElement(App)
	end,
}
