local React = require("@pkg/React")
local Sift = require("@pkg/Sift")
local styles = require("./styles")
local LoadingSpinner = require("./LoadingSpinner")
local ThemeDetails = require("./ThemeDetails")
local fetchExtensionThemes = require("@root/requests/fetchExtensionThemes")
local types = require("@root/types")

local useState = React.useState
local useEffect = React.useEffect

export type Props = {
	extension: types.PublishedExtension,
	onBack: () -> (),
}

local function ThemeDetailsWrapper(props: Props)
	local err, setErr = useState(nil :: string?)
	local themes, setThemes = useState(nil :: { types.ExtensionTheme }?)

	useEffect(function()
		if props.extension.versions then
			local latestVersion = props.extension.versions[1]

			if latestVersion then
				fetchExtensionThemes(props.extension, latestVersion.version)
					:andThen(function(newThemes)
						setThemes(newThemes)
					end)
					:catch(function()
						setErr(`We couldn't find any themes for this extension. Sorry about that!`)
					end)
			else
				setErr(`We couldn't find any themes for this extension. Sorry about that!`)
			end
		end
	end, { props.extension })

	if err then
		return React.createElement(
			"TextLabel",
			Sift.Dictionary.join(styles.text, {
				Text = err,
			})
		)
	elseif themes then
		return React.createElement(ThemeDetails, {
			extension = props.extension,
			themes = themes,
			onBack = props.onBack,
		})
	else
		return React.createElement(LoadingSpinner)
	end
end

return ThemeDetailsWrapper
