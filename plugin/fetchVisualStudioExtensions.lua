local Root = script:FindFirstAncestor("rbxtheme")

local HttpService = game:GetService("HttpService")

local request = require(Root.request)
local urls = require(Root.urls)
local createUrl = require(Root.createUrl)

local function fetchVisualStudioExtensions()
	return request({
		method = "GET",
		url = createUrl(`{urls.SERVER_URL}/extensions`, {
			searchTerm = "theme",
		}),
	}):andThen(function(res)
		return HttpService:JSONDecode(res.Body)
	end)
end

return fetchVisualStudioExtensions
