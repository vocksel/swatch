local openapiTypes = require("./openapi31")
local parseLuauType = require("./parseLuauType")

type ReferenceObject = openapiTypes.ReferenceObject
type OpenAPIObject = openapiTypes.OpenAPIObject

local function generateApiTypes(api: OpenAPIObject): string
	-- print("API", api)
	local luauTypes = {}

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
				table.insert(luauTypes, parseLuauType(name, requestBody))
			end
		end

		if api.components.responses then
			for name, response in api.components.responses do
				table.insert(luauTypes, parseLuauType(name, response))
			end
		end

		if api.components.schemas then
			for name, schema in api.components.schemas do
				table.insert(luauTypes, parseLuauType(name, schema))
			end
		end
	end

	local typesStr = ""
	for _, luauType in luauTypes do
		local body = ""
		if typeof(luauType.body) == "table" then
			body ..= "{\n"
			for key, value in luauType.body do
				body ..= `  {key}: {value}`
			end
			body ..= "}\n"
		else
			body = `{luauType.body}\n`
		end
		typesStr ..= `export type {luauType.name} = {body}`
	end

	return typesStr
end

return generateApiTypes
