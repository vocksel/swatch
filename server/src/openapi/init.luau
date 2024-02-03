local types = require("./typesV3")

export type OpenAPI = types.OpenAPI

return {
	generateApiTypes = require("./generateApiTypes"),
}
