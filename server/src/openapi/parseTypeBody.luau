local types = require("@server/openapi/types")

type Object<T> = types.Object<T>

local function parseTypeBody(object: Object<any>): Object<string | Object<any>>
	local body = {}

	if object.type then
		if object.type == "object" then
			if object.properties then
				for key, value in object.properties do
					local valueType = typeof(value)

					if valueType == "table" then
						valueType = parseTypeBody(value)
					end

					-- TODO: Handle refs

					if object.required then
						local isRequired = table.find(object.required, key)
						-- TODO: Check if properties in OpenAPI objects are required by
						-- default. Right now the assumption is that they are
						if not isRequired then
							valueType ..= "?"
						end
					end

					body[key] = valueType
				end
			else
				body = "{ [string]: any }"
			end
		else
			if object.type == "integer" then
				body = "number"
			else
				body = object.type
			end
		end
	end

	return body
end

return parseTypeBody
