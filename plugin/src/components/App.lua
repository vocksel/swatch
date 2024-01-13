local React = require("@pkg/React")
local Sift = require("@pkg/Sift")
local types = require("@root/types")
local Home = require("./Home")
local ThemeDetails = require("./ThemeDetails")

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
