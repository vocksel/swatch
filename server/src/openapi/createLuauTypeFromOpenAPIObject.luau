local types = require("@server/openapi/types")
local createLuauComment = require("@server/openapi/createLuauComment")

type Object<T> = types.Object<T>

local function createTypePropertiesFromObject(object: Object<any>): Object<string | Object<any>>
	local inner = {}

	if object.type and object.type == "object" and object.properties then
		for key, value in object.properties do
			local valueType = typeof(value)

			if valueType == "table" then
				value = createTypePropertiesFromObject(value)
			end

			if object.required then
				local isRequired = table.find(object.required, key)
				-- TODO: Determine if properties in OpenAPI objects are required
				-- by default
				if isRequired == false then
					valueType ..= "?"
				end
			end

			inner[key] = valueType
		end
	end

	return inner
end

local function createLuauTypeFromOpenAPIObject(object: Object<any>): types.LuauType
	local comment = createLuauComment(object)

	print(object)
	if object.type == "object" then
		local properties = {}

		if object.properties then
			for key, value in object.properties do
				print(key, value)
				if typeof(value) == "table" then
					value = createTypePropertiesFromObject(value)
				else
					value = typeof(value)
				end
				properties[key] = value
			end
		end
		local inner = table.concat(properties, "\n")

		print("properties", properties)

		return properties

		-- local typeString = `export type {name} = \{{inner}\}`
		-- if comment then
		-- 	return `{comment}\n{typeString}`
		-- else
		-- 	return typeString
		-- end
	elseif object.type == "integer" then
		return "number"
	else
		return {
			comment = comment,
			source = typeof(object),
		}
	end

	return {
		name = name,
		comment = createLuauComment(object),
	}
end

return createLuauTypeFromOpenAPIObject
