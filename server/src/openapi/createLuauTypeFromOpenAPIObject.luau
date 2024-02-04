local types = require("@server/openapi/types")
local parseTypeBody = require("@server/openapi/parseTypeBody")
local createLuauComment = require("@server/openapi/createLuauComment")

type Object<T> = types.Object<T>

local function createLuauTypeFromOpenAPIObject(name: string, object: Object<any>): types.LuauType
	local body
	if object.type == "object" then
		body = {}

		if object.properties then
			for key, value in object.properties do
				body[key] = parseTypeBody(value)
			end
		end
	elseif object.type == "integer" then
		body = "number"
	else
		body = object.type
	end

	return {
		body = body,
		comment = createLuauComment(object),
	}
end

return createLuauTypeFromOpenAPIObject
