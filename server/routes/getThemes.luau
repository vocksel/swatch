local process = require("@lune/process")
local fs = require("@lune/fs")
local net = require("@lune/net")
local serde = require("@lune/serde")

local function createExtensionDownloadUrl(publisherName: string, extensionName: string, extensionVersion: string)
	return ("https://%s.gallery.vsassets.io/_apis/public/gallery/publisher/%s/extension/%s/%s/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"):format(
		publisherName,
		publisherName,
		extensionName,
		extensionVersion
	)
end

local function getThemes(request)
	local publisherName = request.query.publisherName
	local extensionName = request.query.extensionName
	local extensionVersion = request.query.extensionVersion

	if not (publisherName or extensionName or extensionVersion) then
		return {
			status = 500,
		}
	end

	local res = net.request({
		method = "GET",
		url = createExtensionDownloadUrl(publisherName, extensionName, extensionVersion),
	})

	local extensionFilename = ("%s-%s-%s"):format(publisherName, extensionName, extensionVersion)

	if res.ok then
		local extensionZipFilename = ("%s.zip"):format(extensionFilename)
		fs.writeFile(extensionZipFilename, res.body)

		process.spawn("unzip", {
			extensionZipFilename,
			"-d",
			extensionFilename,
		})

		local packageJsonPath = ("%s/extension/package.json"):format(extensionFilename)

		if fs.isFile(packageJsonPath) then
			local packageJson = serde.decode("json", fs.readFile(packageJsonPath))

			local contributedThemes = if packageJson.contributes then packageJson.contributes.themes else nil

			if contributedThemes then
				local themes = {}

				-- print("contributedThemes", contributedThemes)

				for _, theme in contributedThemes do
					if theme.path then
						local themeJsonPath = ("%s/extension/%s")
							:format(extensionFilename, theme.path:sub(2, #theme.path))
							:gsub("/+", "/")

						-- print("themeJsonPath", themeJsonPath)

						if fs.isFile(themeJsonPath) then
							local themeJson = serde.decode("json", fs.readFile(themeJsonPath))
							table.insert(themes, themeJson)
						end
					end
				end

				-- print("themes", themes)

				return {
					status = 200,
					body = net.jsonEncode(themes),
				}
			end
		end

		fs.removeFile(extensionZipFilename)
		fs.removeDir(extensionFilename)

		return {
			status = 500,
		}
	else
		return res
	end
end

return {
	route = "/get-themes",
	callback = getThemes,
}
