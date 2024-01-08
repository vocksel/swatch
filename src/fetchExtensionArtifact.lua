local Root = script:FindFirstAncestor("rbxtheme")

local request = require(Root.request)
local urls = require(Root.urls)

local function fetchExtensionArtifact(owner: string, name: string, version: string)
	return request({
		Method = "GET",
		Url = `{urls.MARKETPLACE_APIS_URL}/public/gallery/publishers/{owner}/vsextensions/{name}/{version}/vspackage`,
		Headers = {},
	})
end

return fetchExtensionArtifact
