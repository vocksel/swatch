local React = require("@pkg/React")
local Searchbar = require("./Searchbar")

local useState = React.useState

return {
	story = function()
		local searchTerm, setSearchTerm = useState(nil :: string?)

		return React.createElement(Searchbar, {
			searchTerm = searchTerm,
			onSearch = setSearchTerm,
		})
	end,
}
