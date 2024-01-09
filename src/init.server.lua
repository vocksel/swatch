local fetchVisualStudioExtensions = require(script.fetchVisualStudioExtensions)
local types = require(script.types)
local request = require(script.request)

fetchVisualStudioExtensions({
		includeLatestVersionOnly = true,
	})
	:andThen(function(extensions: { types.Extension })
		print("extensions", extensions)

		local extension = extensions[1]
		local latestVersion = extension.versions[1]

		print("latestVersion", latestVersion)

		local manifest: types.ArtifactFile
		if latestVersion then
			for _, file in latestVersion.files do
				if file.assetType == "Microsoft.VisualStudio.Code.Manifest" then
					manifest = file
				end
			end
		end

		assert(manifest and manifest.source, "No manifest found for {extension.displayName} v{latestVersion.version}")

		if manifest and manifest.source then
			print("source", manifest.source)
			return request({
				Method = "GET",
				Url = manifest.source,
				Headers = {
					["Content-Type"] = "application/json",
					Accept = `application/json; charset=utf-8;`,
				},
			})
		else
			error("No manifest found for artifact: {artifact}")
		end
	end)
	:andThen(function(res)
		local manifest: types.ExtensionManifest = res.Body
		print("manifest", manifest)
	end)
	:catch(function(err)
		print("error:", err)
	end)
