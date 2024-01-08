local Root = script:FindFirstAncestor("rbxtheme")

local HttpService = game:GetService("HttpService")

local Sift = require(Root.Packages.Sift)
local request = require(Root.request)

local MARKETPLACE_URL = "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery"

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

type VsMarketplacePublisher = {
	displayName: string,
	domain: string,
	flags: string,
	isDomainVerified: boolean,
	publisherId: string,
	publisherName: string,
}

export type VsMarketplaceExtension = {
	deploymentType: number,
	displayName: string,
	extensionId: string,
	extensionName: string,
	flags: string,
	lastUpdated: string,
	publishedDate: string,
	publisher: VsMarketplacePublisher,
	releaseDate: string,
	shortDescription: string,
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

local function fetchVisualStudioExtensions(providedOptions: FetchOptions?)
	local options = Sift.Dictionary.join(DEFAULT_FETCH_OPTIONS, providedOptions)

	-- print("options", options)

	local flags = 0
	for _, option in options do
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
					if options.searchThem
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
		assetTypes = {},
		flags = flags,
	}

	-- print("body", body)

	return request({
			Method = "POST",
			Url = MARKETPLACE_URL,
			Body = HttpService:JSONEncode(body),
			Headers = {
				["Content-Type"] = "application/json",
				Accept = `application/json; charset=utf-8; api-version={options.apiVersion}`,
			},
		})
		:andThen(function(res)
			-- print("res", res)
			return HttpService:JSONDecode(res.Body)
		end)
		:andThen(function(res)
			local extensions = res.results[1].extensions
			if extensions then
				return extensions :: { VsMarketplaceExtension }
			else
				return {} :: { VsMarketplaceExtension }
			end
		end)
end

return fetchVisualStudioExtensions
