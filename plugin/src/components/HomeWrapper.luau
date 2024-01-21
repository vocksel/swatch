local React = require("@pkg/React")
local fetchVisualStudioExtensions = require("@root/requests/fetchVisualStudioExtensions")
local types = require("@root/types")
local Home = require("./Home")

type PublishedExtension = types.PublishedExtension

local useEffect = React.useEffect
local useState = React.useState

export type Props = {
	onViewExtension: (extension: PublishedExtension) -> (),
}

local function HomeWrapper(props: Props)
	local extensions, setExtensions = useState({} :: { PublishedExtension })
	local searchTerm, setSearchTerm = useState(nil :: string?)
	local err, setErr = useState(nil :: string?)

	useEffect(function()
		setErr(nil)
		fetchVisualStudioExtensions({
				-- page = page, -- TODO: Increment the page when scrolling to the bottom of the list
				pageSize = 20,
				searchTerm = if searchTerm then searchTerm else "theme",
			})
			:andThen(function(newExtensions)
				setExtensions(newExtensions)
			end)
			:catch(function()
				setErr(`No extensions found. Please try again later`)
			end)
	end, { searchTerm })

	return React.createElement(Home, {
		extensions = extensions,
		err = err,
		searchTerm = searchTerm,
		onSearch = setSearchTerm,
		onViewExtension = props.onViewExtension,
	})
end

return HomeWrapper
