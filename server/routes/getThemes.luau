local fs = require("@lune/fs")
local net = require("@lune/net")
local serde = require("@lune/serde")

local fetchExtension = require("../fetchExtension")

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
							-- FIXME: Both 'net.jsonDecode' and 'serde.decode'
							-- can't handle JSON5, which means this will fail
							-- for some themes that use it.
							--
							-- It would be great if a change could be added in
							-- Lune for this, but worst case a JSON parser can
							-- be installed and spun up as a separate process
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
	end

	return {
		status = 500,
	}
end

return {
	route = "/get-themes",
	callback = getThemes,
}
