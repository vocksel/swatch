local openapiTypes = require("./typesV3")

local function generateApiTypes(api: openapiTypes.OpenAPI): string
	local types = {}

	for pathName, path in api.paths do
		print(pathName, path)

		if path.parameters then
			for paramName, param in path.parameters do
			end
		end
	end

	for name, schema in api.components.schemas do
		table.insert(types, `export type {name} = {"{}"}`)
		print(name, schema)
	end

	return table.concat(types, "\n\n")
end

return generateApiTypes
