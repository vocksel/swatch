local HttpService = game:GetService("HttpService")

local constants = require("@root/constants")
local createUrl = require("./createUrl")
local request = require("./request")

local function fetchVisualStudioExtensions(query: { [string]: any }?)
	return request({
		method = "GET",
		url = createUrl(`{constants.SERVER_URL}/extensions`, query),
	}):andThen(function(res)
		return HttpService:JSONDecode(res.Body)
	end)
end

return fetchVisualStudioExtensions
