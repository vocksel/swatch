local Root = script:FindFirstAncestor("Swatch")

local HttpService = game:GetService("HttpService")

local createUrl = require(Root.createUrl)
local request = require(Root.request)
local types = require(Root.types)
local constants = require(Root.constants)

local function fetchExtensionThemes(extension: types.PublishedExtension, version: string)
	return request({
		method = "GET",
		url = createUrl(`{constants.SERVER_URL}/get-themes`, {
			extensionName = extension.extensionName,
			publisherName = extension.publisher.publisherName,
			extensionVersion = version,
		}),
	}):andThen(function(res)
		return HttpService:JSONDecode(res.Body)
	end)
end

return fetchExtensionThemes
