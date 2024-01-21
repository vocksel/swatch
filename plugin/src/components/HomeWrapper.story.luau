local React = require("@pkg/React")
local HomeWrapper = require("./HomeWrapper")

return {
	story = function()
		return React.createElement(HomeWrapper, {
			onViewExtension = print,
		})
	end,
}
