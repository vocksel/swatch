local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")

return {
	name = script.Parent:GetFullName(),
	storyRoots = {
		script.Parent.components,
	},
	react = React,
	reactRoblox = ReactRoblox,
}
