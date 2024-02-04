local openapiTypes = require("./openapi31")
local parseLuauType = require("./parseLuauType")

type ReferenceObject = openapiTypes.ReferenceObject
type OpenAPIObject = openapiTypes.OpenAPIObject

local function generateApiTypes(api: OpenAPIObject): string
	print("API", api)
	local types = {}

	-- TODO: Should only need handling for `paths` and the various objects under
	-- `components`

	-- for pathName, path in api.paths do
	-- 	print(pathName, path)

	-- 	if path.parameters then
	-- 		for paramName, param in path.parameters do
	-- 		end
	-- 	end
	-- end

	--  TODO: Traverse the entire `api` once and collect anything we'll need
	--  later for processing?

	-- if api.paths then
	-- 	for name, path in api.paths do
	-- 		print(name, path)
	-- 	end
	-- end

	if api.components then
		if api.components.requestBodies then
			for name, requestBody in api.components.requestBodies do
				table.insert(types, parseLuauType(name, requestBody))
			end
		end

		if api.components.responses then
			for name, response in api.components.responses do
				table.insert(types, parseLuauType(name, response))
			end
		end

		if api.components.schemas then
			for name, schema in api.components.schemas do
				table.insert(types, parseLuauType(name, schema))
			end
		end
	end

	return table.concat(types, "\n\n")
end

return generateApiTypes
