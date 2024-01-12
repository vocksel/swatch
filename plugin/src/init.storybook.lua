local Root = script:FindFirstAncestor("rbxtheme")

local React = require(Root.Packages.React)
local ReactRoblox = require(Root.Packages.ReactRoblox)

return {
	storyRoots = {
		script.Parent.components,
	},
	react = React,
	reactRoblox = ReactRoblox,
}
