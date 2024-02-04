local function createTypeCommentFromObject(object: Object<any>): string?
	local comment = {}
	if object.summary then
		table.insert(comment, `-- {object.summary}`)
	end
	if object.summary and object.description then
		table.insert(comment, "--")
	end
	if object.description then
		table.insert(comment, `-- {object.description}`)
	end
	if #comment > 0 then
		return table.concat(comment, "\n")
	else
		return nil
	end
end

type Object<T> = { [string]: T }

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

type LuauType = {
	comment: string?,
	source: Object<any>,
}

local function createLuauTypeFromOpenAPIObject(object: Object<any>): LuauType
	local comment = createTypeCommentFromObject(object)

	if object.type == "object" then
		local properties = {}

		if object.properties then
			for key, value in object.properties do
				properties[key] = createTypePropertiesFromObject(value)
				-- inner ..= `{INDENT}{key}: {createTypePropertiesFromObject(value)}?,\n`
			end
			-- inner
		end
		local inner = table.concat(properties, "\n")

		print(properties)

		local typeString = `export type {name} = \{{inner}\}`
		if comment then
			return `{comment}\n{typeString}`
		else
			return typeString
		end
	else
		return {
			source = typeof(object),
		}
	end
end

return createLuauTypeFromOpenAPIObject
