local Root = script:FindFirstAncestor("Swatch")

local React = require(Root.Packages.React)
local Sift = require(Root.Packages.Sift)
local types = require(Root.types)
local Home = require(Root.Components.Home)
local ThemeDetails = require(Root.Components.ThemeDetails)

local useCallback = React.useCallback
local useState = React.useState

type PublishedExtension = types.PublishedExtension
type ExtensionTheme = types.ExtensionTheme

export type View = "Home" | "ThemeDetails"

export type Props = {
	plugin: Plugin,
}

local function App(_props: Props)
	local view, setView = useState("Home" :: View)
	local viewParams, setViewParams = useState({})

	local onBack = useCallback(function()
		setViewParams({})
		setView("Home")
	end, {})

	local onViewExtension = useCallback(function(extension: PublishedExtension, themes: { ExtensionTheme })
		setViewParams({
			extension = extension,
			themes = themes,
		})
		setView("ThemeDetails")
	end, {})

	return React.createElement("Folder", nil, {
		Home = if view == "Home"
			then React.createElement(Home, {
				onViewExtension = onViewExtension,
			})
			else nil,

		ThemeDetails = if view == "ThemeDetails"
			then React.createElement(
				ThemeDetails,
				Sift.Dictionary.join(viewParams, {
					onBack = onBack,
				})
			)
			else nil,
	})
end

return App
