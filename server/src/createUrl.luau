local net = require("@lune/net")

local function createUrl(baseUrl: string, query: { [string]: any }?)
	if query and next(query) then
		local joinedQuery = {}
		for key, value in query do
			if typeof(value) == "table" then
				value = net.jsonEncode(value)
			else
				value = tostring(value)
			end
			table.insert(joinedQuery, `{key}="{value}"`)
		end

		return `{baseUrl}?{table.concat(joinedQuery, "&")}`
	else
		return baseUrl
	end
end

return createUrl
