-- upstream: https://learn.microsoft.com/en-us/javascript/api/azure-devops-extension-api/extensionqueryflags
local ExtensionQueryFlags = {
	-- None is used to retrieve only the basic extension details.
	None = 0,

	-- IncludeVersions will return version information for extensions returned
	IncludeVersions = 1,

	-- IncludeFiles will return information about which files were found within
	-- the extension that were stored independent of the manifest. When asking
	-- for files, versions will be included as well since files are returned as
	-- a property of the versions. These files can be retrieved using the path
	-- to the file without requiring the entire manifest be downloaded.
	IncludeFiles = 2,

	-- Include the Categories and Tags that were added to the extension
	-- definition.
	IncludeCategoryAndTags = 4,

	-- Include the details about which accounts the extension has been shared
	-- with if the extension is a private extension.
	IncludeSharedAccounts = 8,

	-- Include properties associated with versions of the extension
	IncludeVersionProperties = 16,

	-- Excluding non-validated extensions will remove any extension versions
	-- that either are in the process of being validated or have failed
	-- validation.
	ExcludeNonValidated = 32,

	-- Include the set of installation targets the extension has requested.
	IncludeInstallationTargets = 64,

	-- Include the base uri for assets of this extension
	IncludeAssetUri = 128,

	-- Include the statistics associated with this extension
	IncludeStatistics = 256,

	-- When retrieving versions from a query, only include the latest version of
	-- the extensions that matched. This is useful when the caller doesn't need
	-- all the published versions. It will save a significant size in the
	-- returned payload.
	IncludeLatestVersionOnly = 512,

	-- This flag switches the asset uri to use GetAssetByName instead of CDN
	-- When this is used, values of base asset uri and base asset uri fallback
	-- are switched When this is used, source of asset files are pointed to
	-- Gallery service always even if CDN is available
	UseFallbackAssetUri = 1024,

	-- This flag is used to get all the metadata values associated with the
	-- extension. This is not applicable to VSTS or VSCode extensions and usage
	-- is only internal.
	IncludeMetadata = 2048,

	-- This flag is used to indicate to return very small data for extension
	-- required by VS IDE. This flag is only compatible when querying is done by
	-- VS IDE
	IncludeMinimalPayloadForVsIde = 4096,

	-- This flag is used to get Lcid values associated with the extension. This
	-- is not applicable to VSTS or VSCode extensions and usage is only internal
	IncludeLcids = 8192,

	-- Include the details about which organizations the extension has been
	-- shared with if the extension is a private extension.
	IncludeSharedOrganizations = 16384,

	-- AllAttributes is designed to be a mask that defines all sub-elements of
	-- the extension should be returned. NOTE: This is not actually All flags.
	-- This is now locked to the set defined since changing this enum would be a
	-- breaking change and would change the behavior of anyone using it. Try not
	-- to use this value when making calls to the service, instead be explicit
	-- about the options required.
	AllAttributes = 16863,

	-- Include the details if an extension is in conflict list or not Currently
	-- being used for VSCode extensions.
	IncludeNameConflictInfo = 32768,
}

export type ExtensionQueryFlags = typeof(ExtensionQueryFlags)

return ExtensionQueryFlags
