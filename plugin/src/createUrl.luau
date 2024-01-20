local HttpService = game:GetService("HttpService")

local function createUrl(baseUrl: string, query: { [string]: any }?)
	if query then
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

		return `{baseUrl}?joinedQuery`
	else
		return baseUrl
	end
end

return createUrl
