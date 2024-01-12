local HttpService = game:GetService("HttpService")

local function createUrl(baseUrl: string, query: { [string]: any })
	local joinedQuery = ""
	for key, value in query do
		if typeof(value) == "table" then
			value = HttpService:JSONEncode(value)
		else
			value = tostring(value)
		end
		joinedQuery ..= `{key}={value}&`
	end

	-- Remove the last ampersand (&) from the query string
	joinedQuery = joinedQuery:gsub("&$", "")

	return ("%s?%s"):format(baseUrl, joinedQuery)
end

return createUrl
