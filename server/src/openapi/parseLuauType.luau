local types = require("@server/openapi/types")
local parseLuauTypeBody = require("@server/openapi/parseLuauTypeBody")
local parseLuauComment = require("@server/openapi/parseLuauComment")

type Object<T> = types.Object<T>

local function parseLuauType(name: string, object: Object<any>): types.LuauType
	local body
	if object.type == "object" then
		body = {}

		if object.properties then
			for key, value in object.properties do
				body[key] = parseLuauTypeBody(value)
			end
		end
	elseif object.type == "integer" then
		body = "number"
	else
		body = object.type
	end

	return {
		body = body,
		comment = parseLuauComment(object),
	}
end

return parseLuauType
