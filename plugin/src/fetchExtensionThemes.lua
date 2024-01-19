local HttpService = game:GetService("HttpService")

local createUrl = require("@root/createUrl")
local constants = require("@root/constants")
local request = require("@root/request")
local types = require("@root/types")

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
