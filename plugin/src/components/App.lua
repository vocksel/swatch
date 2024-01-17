local Root = script:FindFirstAncestor("Swatch")

local React = require(Root.Packages.React)
local types = require(Root.types)
local Home = require(Root.Components.Home)
local ThemeDetailsWrapper = require(Root.Components.ThemeDetailsWrapper)

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
	local extension, setExtension = useState(nil :: PublishedExtension?)

	local onBack = useCallback(function()
		setExtension(nil)
		setView("Home")
	end, {})

	local onViewExtension = useCallback(function(selectedExtension: PublishedExtension)
		setExtension(selectedExtension)
		setView("ThemeDetails")
	end, {})

	return React.createElement("Folder", nil, {
		Home = if view == "Home"
			then React.createElement(Home, {
				onViewExtension = onViewExtension,
			})
			else nil,

		ThemeDetails = if view == "ThemeDetails"
			then React.createElement(ThemeDetailsWrapper, {
				extension = extension,
				onBack = onBack,
			})
			else nil,
	})
end

return App
