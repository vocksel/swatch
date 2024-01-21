local net = require("@lune/net")
local fetch = require("../fetch")

export type FetchOptions = {
	searchTerm: string?,
	pageLimit: number?,
	pageSize: number?,
	includeVersions: boolean?,
	includeFiles: boolean?,
	includeCategoryAndTags: boolean?,
	includeSharedAccounts: boolean?,
	includeVersionProperties: boolean?,
	excludeNonValidated: boolean?,
	includeInstallationTargets: boolean?,
	includeAssetUri: boolean?,
	includeStatistics: boolean?,
	includeLatestVersionOnly: boolean?,
	unpublished: boolean?,
	includeNameConflictInfo: boolean?,
	apiVersion: string?,
}

local DEFAULT_FETCH_OPTIONS: FetchOptions = {
	pageLimit = 10000,
	pageSize = 100,
	includeVersions = true,
	includeFiles = true,
	includeCategoryAndTags = true,
	includeSharedAccounts = true,
	includeVersionProperties = true,
	excludeNonValidated = false,
	includeInstallationTargets = true,
	includeAssetUri = true,
	includeStatistics = true,
	includeLatestVersionOnly = false,
	unpublished = false,
	includeNameConflictInfo = true,
	apiVersion = "7.2-preview.1",
}

type InternalFetchOptions = FetchOptions & typeof(DEFAULT_FETCH_OPTIONS)

local OPTION_TO_FLAG_MAP = {
	includeVersions = 0x1,
	includeFiles = 0x2,
	includeCategoryAndTags = 0x4,
	includeSharedAccounts = 0x8,
	includeVersionProperties = 0x10,
	excludeNonValidated = 0x20,
	includeInstallationTargets = 0x40,
	includeAssetUri = 0x80,
	includeStatistics = 0x100,
	includeLatestVersionOnly = 0x200,
	unpublished = 0x1000,
	includeNameConflictInfo = 0x8000,
}

local function getExtensions(request)
	local options = table.clone(DEFAULT_FETCH_OPTIONS)
	for key, value in request.query do
		options[key] = value
	end

	-- print("options", options)

	local flags = 0
	for option in options do
		local flag = OPTION_TO_FLAG_MAP[option]
		if flag then
			flags = bit32.bxor(flags, flag)
		end
	end

	-- print("flags", flags)

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
			Accept = `application/json; charset=utf-8; api-version={options.apiVersion}`,
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
