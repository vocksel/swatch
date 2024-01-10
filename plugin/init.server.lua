local fetchVisualStudioExtensions = require(script.fetchVisualStudioExtensions)
local fetchExtensionThemes = require(script.fetchExtensionThemes)
local types = require(script.types)

fetchVisualStudioExtensions({
		searchTerm = "theme",
		includeLatestVersionOnly = true,
	})
	:andThen(function(extensions: { types.Extension })
		local extension = extensions[1]
		local latestVersion = extension.versions[1]

		assert(latestVersion, "No latest version found for extension {extension.displayName}")

		return fetchExtensionThemes(extension, latestVersion.version)
	end)
	:andThen(function(themes)
		print("themes", themes)
		print(require(script.getThemeColors)(themes[1]))
	end)
	:catch(function(err)
		print("error:", err)
	end)
