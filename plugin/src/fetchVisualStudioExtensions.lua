local HttpService = game:GetService("HttpService")

local request = require("@root/request")
local urls = require("@root/urls")
local createUrl = require("@root/createUrl")

local function fetchVisualStudioExtensions(query: { [string]: any }?)
	return request({
		method = "GET",
		url = createUrl(`{urls.SERVER_URL}/extensions`, query),
	}):andThen(function(res)
		return HttpService:JSONDecode(res.Body)
	end)
end

return fetchVisualStudioExtensions
