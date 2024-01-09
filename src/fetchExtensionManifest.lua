local Root = script:FindFirstAncestor("rbxtheme")

local HttpService = game:GetService("HttpService")

local request = require(Root.request)
local types = require(Root.types)

local function fetchExtensionManifest(extension: types.ExtensionVersion)
	local manifest: types.ArtifactFile
	for _, file in extension.files do
		if file.assetType == "Microsoft.VisualStudio.Code.Manifest" then
			manifest = file
		end
	end

	assert(manifest and manifest.source, "No manifest found for {extension.displayName} v{latestVersion.version}")

	return request({
		Method = "GET",
		Url = manifest.source,
		Headers = {
			["Content-Type"] = "application/json",
			Accept = `application/json; charset=utf-8;`,
		},
	}):andThen(function(res)
		return HttpService:JSONDecode(res.Body)
	end)
end

return fetchExtensionManifest
