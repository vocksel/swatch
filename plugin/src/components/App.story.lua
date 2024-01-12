local Root = script:FindFirstAncestor("rbxtheme")

local React = require(Root.Packages.React)
local App = require(script.Parent.App)

local mockPlugin = {}

return {
	story = function()
		return React.createElement(App, {
			plugin = mockPlugin,
		})
	end,
}
