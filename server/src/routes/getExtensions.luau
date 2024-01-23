local net = require("@lune/net")
local fetch = require("../fetch")
local ExtensionQueryFlags = require("../enums/ExtensionQueryFlags")

type ExtensionQueryFlags = ExtensionQueryFlags.ExtensionQueryFlags

local API_VERSION = "7.2-preview.1"

local FLAGS: { ExtensionQueryFlags } = {
	ExtensionQueryFlags.IncludeLatestVersionOnly,
}

export type FetchOptions = {
	searchTerm: string?,
	pageSize: number?,
	page: number?,
}

local DEFAULT_FETCH_OPTIONS: FetchOptions = {
	pageSize = 10,
	page = 1,
}

type InternalFetchOptions = FetchOptions & typeof(DEFAULT_FETCH_OPTIONS)

local function getExtensions(request)
	local options = table.clone(DEFAULT_FETCH_OPTIONS)
	for key, value in request.query do
		options[key] = value
	end

	local flags = 0
	for _, flag in FLAGS do
		flags += flag
	end

	local body = {
		filters = {
			{
				criteria = {
					{
						filterType = 8,
						value = "Microsoft.VisualStudio.Code",
					},
					if options.searchTerm
						then {
							filterType = 10,
							value = options.searchTerm,
						}
						else nil,
				},
				pageNumber = options.page,
				pageSize = options.pageSize,
				sortBy = 0,
				sortOrder = 0,
			},
		},
		-- assetTypes = {},
		flags = flags,
	}

	local res = fetch({
		method = "POST",
		url = "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery",
		body = net.jsonEncode(body),
		headers = {
			["Content-Type"] = "application/json",
			Accept = `application/json; charset=utf-8; api-version={API_VERSION}`,
		},
	})

	local responseBody = net.jsonDecode(res.body)

	if responseBody then
		local extensions = responseBody.results[1].extensions

		if extensions then
			return {
				status = 200,
				headers = {
					["Content-Type"] = "application/json",
				},
				body = net.jsonEncode(extensions),
			}
		end
	end

	return {
		status = 500,
	}
end

return {
	route = "/v1/extensions",
	callback = getExtensions,
}
