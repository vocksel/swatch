local React = require("@pkg/React")
local ReactRoblox = require("@pkg/ReactRoblox")

return {
	name = `{script.Parent.Name} ({script.Parent.Parent.Name})`,
	storyRoots = {
		script.Parent.components,
	},
	react = React,
	reactRoblox = ReactRoblox,
}
