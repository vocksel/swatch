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

export type ExtensionVersionArtifact = {
	assetUri: string,
	fallbackAssetUri: string,
	files: { ArtifactFile },
	flags: string,
	lastUpdated: string,
	properties: { ArtifactProperty },
	version: string,
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
	versions: { ExtensionVersionArtifact },
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
	contributes: { any }, -- stub
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

return nil
