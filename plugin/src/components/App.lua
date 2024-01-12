local Root = script:FindFirstAncestor("rbxtheme")

local React = require(Root.Packages.React)
local fetchVisualStudioExtensions = require(Root.fetchVisualStudioExtensions)

type VsMarketplaceExtension = fetchVisualStudioExtensions.VsMarketplaceExtension

local useEffect = React.useState
local useState = React.useState

export type Props = {
	plugin: Plugin,
}

local function App(_props: Props)
	local extensions, setExtensions = useState({} :: { VsMarketplaceExtension })

	useEffect(function()
		fetchVisualStudioExtensions({
			searchTerm = "theme",
		}):andThen(function(newExtensions)
			print("extensions", newExtensions)
			setExtensions(newExtensions)
		end)
	end, {})

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		SearchForm = React.createElement("Frame", {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, {
			Input = React.createElement("TextBox", {
				PlaceholderText = "Search themes...",
			}),

			ErrorMessage = React.createElement("TextLabel", {}),
		}),

		Extensions = React.createElement("TextLabel", {
			LayoutOrder = 2,
			Text = tostring(extensions),
		}),
	})
end

return App
