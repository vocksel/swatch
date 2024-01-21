local React = require("@pkg/React")
local types = require("@root/types")
local ExtensionsList = require("./ExtensionsList")

-- TODO: Just use a real web response
local function createMockExtension(name: string): types.PublishedExtension
	return {
		categories = {},
		deploymentType = 0,
		displayName = name,
		extensionId = "1",
		extensionName = name,
		flags = "",
		installationTargets = {},
		lastUpdated = tostring(DateTime.now()),
		longDescription = "",
		presentInConflictList = "",
		publishedDate = tostring(DateTime.now()),
		publisher = {
			displayName = "OnlyTwentyCharacters",
			domain = "",
			flags = "",
			isDomainVerified = false,
			publisherId = "",
			publisherName = "",
		},
		releaseDate = tostring(DateTime.now()),
		sharedWith = {},
		shortDescription = "",
		statistics = {},
		tags = {},
		versions = {
			{
				version = "1.2.3",
				versionDescription = "",
				assetUri = "",
				fallbackAssetUri = "",
				files = {},
				flags = 0,
				badges = {},
				targetPlatform = "",
				lastUpdated = "",
				properties = {},
				validationResultMessage = "",
			},
		},
	}
end

local controls = {
	numExtensions = 10,
}

type Props = {
	controls: {
		numExtensions: number,
	},
}

return {
	controls = controls,
	story = function(props: Props)
		local extensions = {}
		print(props.controls.numExtensions)
		for i = 1, props.controls.numExtensions do
			table.insert(extensions, createMockExtension(`Extension {i}`))
		end

		return React.createElement(ExtensionsList, {
			extensions = extensions,
			onView = print,
		})
	end,
}
