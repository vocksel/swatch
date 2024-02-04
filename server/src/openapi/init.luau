local types = require("./openapi31")

export type OpenAPIObject = types.OpenAPIObject

return {
	generateApiTypes = require("./generateApiTypes"),
}
