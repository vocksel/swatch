local process = require("@lune/process")
local fs = require("@lune/fs")
local fetch = require("./fetch")

local EXTENSIONS_DIR = "extensions"

local function createExtensionDownloadUrl(
	publisherName: string,
	extensionName: string,
	extensionVersion: string
): string
	return `https://{publisherName}.gallery.vsassets.io/_apis/public/gallery/publisher/{publisherName}/extension/`
		.. `{extensionName}/{extensionVersion}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage`
end

local function fetchExtension(publisherName: string, extensionName: string, extensionVersion: string): string?
	if not fs.isDir(EXTENSIONS_DIR) then
		fs.writeDir(EXTENSIONS_DIR)
	end

	local extensionPath = `{EXTENSIONS_DIR}/{publisherName}-{extensionName}-{extensionVersion}`

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

return fetchExtension
