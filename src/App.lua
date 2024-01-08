local Root = script:FindFirstAncestor("rbxtheme")

local React = require(Root.Packages.React)
local fetchVisualStudioExtensions = require(Root.fetchVisualStudioExtensions)

type VsMarketplaceExtension = fetchVisualStudioExtensions.VsMarketplaceExtension

local useEffect = React.useState
local useState = React.useState

export type Props = {
	plugin: Plugin,
}

local function App(props: Props)
	local extensions, setExtensions = useState({} :: { VsMarketplaceExtension })

	useEffect(function()
		fetchVisualStudioExtensions():andThen(function(newExtensions)
			print("extensions", newExtensions)
			setExtensions(newExtensions)
		end)
	end, {})

	return React.createElement("TextLabel", {
		Text = tostring(extensions),
	})
end

return App
