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

--[[
def get_vscode_extensions(
    max_page=10000,
    page_size=100,
    include_versions=True,
    include_files=True,
    include_category_and_tags=True,
    include_shared_accounts=True,
    include_version_properties=True,
    exclude_non_validated=False,
    include_installation_targets=True,
    include_asset_uri=True,
    include_statistics=True,
    include_latest_version_only=False,
    unpublished=False,
    include_name_conflict_info=True,
    api_version="7.2-preview.1",
    session=None,
):
    if not session:
        session = requests.session()

    headers = {"Accept": f"application/json; charset=utf-8; api-version={api_version}"}

    flags = 0
    if include_versions:
        flags |= 0x1

    if include_files:
        flags |= 0x2

    if include_category_and_tags:
        flags |= 0x4

    if include_shared_accounts:
        flags |= 0x8

    if include_shared_accounts:
        flags |= 0x8

    if include_version_properties:
        flags |= 0x10

    if exclude_non_validated:
        flags |= 0x20

    if include_installation_targets:
        flags |= 0x40

    if include_asset_uri:
        flags |= 0x80

    if include_statistics:
        flags |= 0x100

    if include_latest_version_only:
        flags |= 0x200

    if unpublished:
        flags |= 0x1000

    if include_name_conflict_info:
        flags |= 0x8000

    for page in range(1, max_page + 1):
        body = {
            "filters": [
                {
                    "criteria": [
                        {"filterType": 8, "value": "Microsoft.VisualStudio.Code"}
                    ],
                    "pageNumber": page,
                    "pageSize": page_size,
                    "sortBy": 0,
                    "sortOrder": 0,
                }
            ],
            "assetTypes": [],
            "flags": flags,
        }

        r = session.post(
            "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery",
            json=body,
            headers=headers,
        )
        r.raise_for_status()
        response = r.json()

        extensions = response["results"][0]["extensions"]
        for extension in extensions:
            yield extension

        if len(extensions) != page_size:
            break


def main():
    retry_strategy = Retry(
        total=3,
        backoff_factor=1,
        status_forcelist=[429, 500, 502, 503, 504],
        allowed_methods=["HEAD", "GET", "OPTIONS"],
    )
    adapter = HTTPAdapter(max_retries=retry_strategy)
    session = requests.Session()
    session.mount("https://", adapter)
    session.mount("http://", adapter)

    for extension in get_vscode_extensions(session=session, page_size=10):
        extension_name = extension["extensionName"]
        extension_description = extension["extensionName"]
        extensions_versions = extension["versions"]
        extensions_statistics = dict(
            {(item["statisticName"], item["value"]) for item in extension["statistics"]}
        )
        extension_publisher_username = extension["publisher"]["publisherName"]

        for extension_version_info in extensions_versions:
            extension_version = extension_version_info["version"]
            extension_artifact_download_url = f"https://marketplace.visualstudio.com/_apis/public/gallery/publishers/{extension_publisher_username}/vsextensions/{extension_name}/{extension_version}/vspackage"
            -- print(
                extension_name,
                extension_description,
                extension_version,
                extension_artifact_download_url,
                extensions_statistics["install"],
            )


if __name__ == "__main__":
    main()
]]
