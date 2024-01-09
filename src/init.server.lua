local fetchVisualStudioExtensions = require(script.fetchVisualStudioExtensions)
local fetchExtensionManifest = require(script.fetchExtensionManifest)
local fetchExtensionThemes = require(script.fetchExtensionThemes)
local fetchExtensionArtifact = require(script.fetchExtensionArtifact)
local types = require(script.types)

fetchVisualStudioExtensions({
		searchTerm = "theme",
		includeLatestVersionOnly = true,
	})
	:andThen(function(extensions: { types.Extension })
		local extension = extensions[1]
		local latestVersion = extension.versions[1]

		assert(latestVersion, "No latest version found for extension {extension.displayName}")

		-- The resulting vsix file should be able to be unzipped, but I don't think that's possible in Roblox
		local success, artifact = fetchExtensionArtifact(
			extension.publisher.publisherName,
			extension.extensionName,
			latestVersion.version
		):await()
		print("artifact", artifact)

		local _success, manifest = fetchExtensionManifest(latestVersion):await()

		return extension, manifest
	end)
	-- :andThen(function(extension: types.Extension, manifest: types.ExtensionManifest)
	-- 	print("extension", extension, "manifest", manifest)
	-- 	return fetchExtensionThemes(extension, manifest)
	-- end)
	-- :andThen(function(themes)
	-- 	print("themes", themes)
	-- end)
	:catch(
		function(err)
			print("error:", err)
		end
	)
