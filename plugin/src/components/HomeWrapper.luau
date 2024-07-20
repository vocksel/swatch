local React = require("@pkg/React")
local Sift = require("@pkg/Sift")
local fetchVisualStudioExtensions = require("@root/requests/fetchVisualStudioExtensions")
local types = require("@root/types")
local Home = require("./Home")

type PublishedExtension = types.PublishedExtension

local useCallback = React.useCallback
local useEffect = React.useEffect
local useState = React.useState

export type Props = {
	onViewExtension: (extension: PublishedExtension) -> (),
}

local function HomeWrapper(props: Props)
	local page, setPage = useState(1)
	local extensions, setExtensions = useState({} :: { PublishedExtension })
	local searchTerm, setSearchTerm = useState(nil :: string?)
	local err: string?, setErr = useState(nil :: string?)

	local onFetchMore = useCallback(function()
		setPage(function(prev)
			return prev + 1
		end)
	end, {})

	useEffect(function()
		setPage(1)
	end, { searchTerm })

	useEffect(function()
		setErr(nil)
		fetchVisualStudioExtensions({
				page = page,
				pageSize = 20,
				searchTerm = if searchTerm then searchTerm else "theme",
			})
			:andThen(function(newExtensions)
				setExtensions(function(prev)
					if page > 1 then
						return Sift.Array.join(prev, newExtensions)
					else
						return newExtensions
					end
				end)
			end)
			:catch(function()
				setErr(`No extensions found. Please try again later`)
			end)
	end, { searchTerm, page })

	return React.createElement(Home, {
		extensions = extensions,
		err = err,
		searchTerm = searchTerm,
		onSearch = setSearchTerm,
		onFetchMore = onFetchMore,
		onViewExtension = props.onViewExtension,
	})
end

return HomeWrapper
