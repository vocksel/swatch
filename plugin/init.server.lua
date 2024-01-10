local fetchVisualStudioExtensions = require(script.fetchVisualStudioExtensions)
local fetchExtensionThemes = require(script.fetchExtensionThemes)
local types = require(script.types)
local urls = require(script.urls)
local request = require(script.request)

request({
		url = `{urls.SERVER_URL}/health`,
		polling = {
			retries = 5,
			delay = 10,
		},
	})
	:andThen(function()
		print("Established connection to server")

		return fetchVisualStudioExtensions({
			searchTerm = "theme",
			includeLatestVersionOnly = true,
		})
	end)
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
