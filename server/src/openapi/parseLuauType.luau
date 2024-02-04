local types = require("@server/openapi/types")
local openapiTypes = require("@server/openapi/openapi31")
local parseLuauTypeBody = require("@server/openapi/parseLuauTypeBody")
local parseLuauComment = require("@server/openapi/parseLuauComment")

type SchemaObject = openapiTypes.SchemaObject

local function parseLuauType(name: string, schema: SchemaObject): types.LuauType
	local body
	if schema.type == "object" then
		body = {}

		if schema.properties then
			for key, value in schema.properties do
				body[key] = parseLuauTypeBody(value)
			end
		end
	else
		body = parseLuauTypeBody(schema)
	end

	return {
		name = name,
		body = body,
		comment = parseLuauComment(schema),
	}
end

return parseLuauType
