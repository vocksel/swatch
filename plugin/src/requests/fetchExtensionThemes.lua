local HttpService = game:GetService("HttpService")

local constants = require("@root/constants")
local types = require("@root/types")
local createUrl = require("./createUrl")
local request = require("./request")

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
