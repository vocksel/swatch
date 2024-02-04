local fs = require("@lune/fs")
local serde = require("@lune/serde")
local openapiTypes = require("@server/openapi/openapi31")
local generateApiTypes = require("./generateApiTypes")

type OpenAPIObject = openapiTypes.OpenAPIObject

local api: OpenAPIObject = serde.decode("yaml", fs.readFile("server/src/openapi/mocks/commented-schema.yml"))
local snapshot = fs.readFile("server/src/openapi/mocks/petstore-types.luau")

local generatedTypes = generateApiTypes(api)

assert(generatedTypes == snapshot, "generated types don't match snapshot")
