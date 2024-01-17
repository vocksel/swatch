local Root = script:FindFirstAncestor("Swatch")

local HttpService = game:GetService("HttpService")

local request = require(Root.request)
local constants = require(Root.constants)
local createUrl = require(Root.createUrl)

local function fetchVisualStudioExtensions(query: { [string]: any }?)
	return request({
		method = "GET",
		url = createUrl(`{constants.SERVER_URL}/extensions`, query),
	}):andThen(function(res)
		return HttpService:JSONDecode(res.Body)
	end)
end

return fetchVisualStudioExtensions
