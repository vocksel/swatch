local Root = script:FindFirstAncestor("rbxtheme")

local HttpService = game:GetService("HttpService")

local Promise = require(Root.Packages.Promise)
local request = require(Root.request)
local types = require(Root.types)

local function fetchExtensionThemes(extension: types.ExtensionVersion, manifest: types.ExtensionManifest)
	local promises = {}
	local baseUrl = manifest.repository.url
	local themes = if manifest.contributes.themes then manifest.contributes.themes else manifest.themes

	for _, theme in themes do
		print(theme.label)
		local promise = request({
			Method = "GET",
			Url = `{baseUrl}/{theme.path}`,
			Headers = {
				["Content-Type"] = "application/json",
				Accept = `application/json; charset=utf-8;`,
			},
		}):andThen(function(res)
			print("res", res)
			return HttpService:JSONDecode(res.Body)
		end)

		table.insert(promises, promise)
	end

	return Promise.all(promises)
end

return fetchExtensionThemes
