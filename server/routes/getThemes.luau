local process = require("@lune/process")
local fs = require("@lune/fs")
local net = require("@lune/net")
local serde = require("@lune/serde")
local fetch = require("../fetch")

local function createExtensionDownloadUrl(
	publisherName: string,
	extensionName: string,
	extensionVersion: string
): string
	return `https://{publisherName}.gallery.vsassets.io/_apis/public/gallery/publisher/{publisherName}/extension/`
		.. `{extensionName}/{extensionVersion}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage`
end

local function fetchExtension(publisherName: string, extensionName: string, extensionVersion: string): string?
	local extensionPath = `{publisherName}-{extensionName}-{extensionVersion}`

	if fs.isDir(extensionPath) then
		return extensionPath
	else
		local res = fetch({
			method = "GET",
			url = createExtensionDownloadUrl(publisherName, extensionName, extensionVersion),
		})

		if res.ok then
			local zipPath = `{extensionPath}.zip`

			fs.writeFile(zipPath, res.body)
			res = process.spawn("unzip", { zipPath, "-d", extensionPath })
			fs.removeFile(zipPath)

			if res.ok then
				return extensionPath
			end
		end

		return nil
	end
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

	local extensionPath = fetchExtension(publisherName, extensionName, extensionVersion)

	if extensionPath then
		local packageJsonPath = `{extensionPath}/extension/package.json`

		if fs.isFile(packageJsonPath) then
			local packageJson = serde.decode("json", fs.readFile(packageJsonPath))

			local contributedThemes = if packageJson.contributes then packageJson.contributes.themes else nil

			if contributedThemes then
				local themes = {}

				for _, theme in contributedThemes do
					if theme.path then
						local partialThemePath = theme.path:gsub("%./", "")
						local themeJsonPath = (`{extensionPath}/extension/{partialThemePath}`):gsub("//", "/")

						if fs.isFile(themeJsonPath) then
							local themeJson = serde.decode("json", fs.readFile(themeJsonPath))
							table.insert(themes, themeJson)
						end
					end
				end

				return {
					status = 200,
					body = net.jsonEncode(themes),
				}
			end
		end

		fs.removeDir(extensionPath)
	end

	return {
		status = 500,
	}
end

return {
	route = "/get-themes",
	callback = getThemes,
}
