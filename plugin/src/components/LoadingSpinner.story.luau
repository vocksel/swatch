local React = require("@pkg/React")
local LoadingSpinner = require("./LoadingSpinner")

return {
	story = function()
		return React.createElement(LoadingSpinner)
	end,
}
