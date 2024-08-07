local React = require("@pkg/React")
local types = require("@root/types")
local HomeWrapper = require("./HomeWrapper")
local ThemeDetailsWrapper = require("./ThemeDetailsWrapper")

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
	local searchTerm, setSearchTerm = useState(nil :: string?)

	local onBack = useCallback(function()
		setExtension(nil)
		setView("Home")
	end, {})

	local onViewExtension = useCallback(function(selectedExtension: PublishedExtension)
		setExtension(selectedExtension)
		setView("ThemeDetails")
	end, {})

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, {
		Home = if view == "Home"
			then React.createElement(HomeWrapper, {
				onSearch = setSearchTerm,
				onViewExtension = onViewExtension,
				searchTerm = searchTerm,
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
