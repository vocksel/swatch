local openapiTypes = require("./openapi31")

type OpenAPIObject = openapiTypes.OpenAPIObject

local function getObjectFromApiRef(api: OpenAPIObject, ref: string): { [string]: any }?
	local parts = ref:gsub("#/", ""):split("/")
	print(parts)
	local object
	for _, part in parts do
		object = rawget(api, part)
		if not object then
			error(`invalid API ref: {ref}. Made it to: "{part}"`)
			return nil
		end
	end
	return object
end

local function getObjectFromPathRef(api: OpenAPIObject, ref: string)
	-- TODO
end

local function getObjectFromRef(api: OpenAPIObject, ref: string)
	-- Refs that point to an object within the spec uses `#/`, and refs that
	-- point to another json/yaml file uses normal unix path syntax
	if ref:match("#/") then
		return getObjectFromApiRef(api, ref)
	else
		return getObjectFromPathRef(api, ref)
	end
end

return getObjectFromRef
