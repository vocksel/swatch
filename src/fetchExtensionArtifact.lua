local Root = script:FindFirstAncestor("rbxtheme")

local HttpService = game:GetService("HttpService")

local request = require(Root.request)
-- local urls = require(Root.urls)

local function fetchExtensionArtifact(owner: string, name: string, version: string)
	-- At this point, I think I'm going to need a small web server that can handle downloading vsix files, unzipping them, and returning theme info
	return request({
		Method = "GET",
		Url = `https://{owner}.gallery.vsassets.io/_apis/public/gallery/publisher/{owner}/extension/{name}/{version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage`,
		-- Url = `{urls.MARKETPLACE_APIS_URL}/public/gallery/publishers/{owner}/vsextensions/{name}/{version}/vspackage`,
		Headers = {
			["Content-Type"] = "application/json",
			Accept = `application/json; charset=utf-8;`,
		},
	})
end

return fetchExtensionArtifact
