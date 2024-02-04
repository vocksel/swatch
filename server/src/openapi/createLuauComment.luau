local types = require("@server/openapi/types")

type Object<T> = types.Object<T>

local function createLuauComment(object: Object<any>): string?
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

return createLuauComment
