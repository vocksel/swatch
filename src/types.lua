type ArtifactFileAssetType =
	"Microsoft.VisualStudio.Code.Manifest"
	| "Microsoft.VisualStudio.Services.Content.Changelog"
	| "Microsoft.VisualStudio.Services.Content.Details"
	| "Microsoft.VisualStudio.Services.Content.License"

export type Publisher = {
	displayName: string,
	domain: string,
	flags: string,
	isDomainVerified: boolean,
	publisherId: string,
	publisherName: string,
}

export type InstallationTarget = {
	target: string,
	targetVersion: string,
}

export type ExtensionStatistic = {
	statisticName: string,
	value: any,
}

export type ArtifactFile = {
	assetType: ArtifactFileAssetType,
	source: string,
}

export type ArtifactProperty = {
	key: string,
	value: any,
}

export type ExtensionProperty = ArtifactProperty

export type ExtensionBadge = {}

export type ExtensionFile = ArtifactFile

export type ExtensionVersion = {

	assetUri: string,
	badges: { ExtensionBadge },
	fallbackAssetUri: string,
	files: { ExtensionFile },
	flags: number,
	lastUpdated: string,
	properties: { ExtensionProperty },
	targetPlatform: string,
	validationResultMessage: string,
	version: string,
	versionDescription: string,
}

export type Extension = {
	categories: { string },
	deploymentType: number,
	displayName: string,
	extensionId: string,
	extensionName: string,
	flags: string,
	installationTargets: { InstallationTarget },
	lastUpdated: string,
	publishedDate: string,
	publisher: Publisher,
	releaseDate: string,
	shortDescription: string,
	statistics: { ExtensionStatistic },
	tags: { string },
	versions: { ExtensionVersion },
}

type ExtensionCapabilities = {
	description: string,
	supported: string,
}

export type ExtensionManifest = {
	activationEvents: { string },
	author: {
		name: string,
	},
	browser: string,
	bugs: {
		url: string,
	},
	capabilities: {
		[string]: ExtensionCapabilities,
	},
	categories: { string },
	contributes: {
		themes: {
			label: string,
			path: string,
			uiTheme: string,
		},
	}, -- stub
	dependencies: { [string]: string },
	description: string,
	devDependencies: { [string]: string },
	displayName: string,
	enableTelemetry: boolean,
	enabledApiProposals: { string },
	engines: { [string]: string },
	extensionPack: { string },
	featureFlags: { [string]: boolean },
	galleryBanner: { color: string, theme: string },
	homepage: string,
	icon: string,
	keywords: { string },
	l10n: string,
	license: string,
	main: string,
	name: string,
	publisher: string,
	qna: string,
	repository: {
		type: string,
		url: string,
	},
	scripts: {
		[string]: string,
	},
	version: string,
	themes: { any }, -- stub
}

-- Upstream: https://learn.microsoft.com/en-us/javascript/api/azure-devops-extension-api/

export type FilterCriteria = {
	filterType: number,
	value: string,
}

export type QueryFilter = {
	criteria: { FilterCriteria },
	direction: number,
	pageNumber: number,
	pageSize: number,
	pagingToken: string,
	sortBy: number,
	sortOrder: number,
}

export type ExtensionQuery = {
	assetTypes: { string },
	filters: { QueryFilter },
	flags: number,
}

export type PublisherFacts = Publisher

export type PublishedExtension = {
	categories: { string },
	deploymentType: number,
	displayName: string,
	extensionId: string,
	extensionName: string,
	flags: string,
	installationTargets: { InstallationTarget },
	lastUpdated: string,
	longDescription: string,
	presentInConflictList: string,
	publishedDate: string,
	publisher: PublisherFacts,
	releaseDate: string,
	sharedWith: { any },
	shortDescription: string,
	statistics: { ExtensionStatistic },
	tags: { string },
	versions: { ExtensionVersion },
}

export type ExtensionFilterResult = {
	extensions: { PublishedExtension },
	pagingToken: string?,
	resultMetadata: { any },
}

export type ExtensionQueryResult = {
	results: { ExtensionFilterResult },
}

return nil
