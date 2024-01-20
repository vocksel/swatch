local HttpService = game:GetService("HttpService")

local request = require("@root/request")
local constants = require("@root/constants")
local createUrl = require("@root/createUrl")

local function fetchVisualStudioExtensions(query: { [string]: any }?)
	return request({
		method = "GET",
		url = createUrl(`{constants.SERVER_URL}/extensions`, query),
	}):andThen(function(res)
		return HttpService:JSONDecode(res.Body)
	end)
end

return fetchVisualStudioExtensions
