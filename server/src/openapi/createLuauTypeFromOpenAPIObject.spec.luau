local fs = require("@lune/fs")
local serde = require("@lune/serde")
local openapiTypes = require("@server/openapi/openapi31")
local createLuauTypeFromOpenAPIObject = require("./createLuauTypeFromOpenAPIObject")

type OpenAPIObject = openapiTypes.OpenAPIObject

local petstore: OpenAPIObject = serde.decode("yaml", fs.readFile("server/src/openapi/mocks/petstore.yml"))

-- print(petstore)

assert(petstore.components.schemas, "no schemas found in mock API")

local schemas = createLuauTypeFromOpenAPIObject(petstore.components.schemas)

print("schemas", schemas)

assert(schemas.Pet, "missing type Pet")
assert(schemas.Pets, "missing type Pets")
assert(schemas.Error, "missing type Error")

-- assert(nil, "summary is not included in type comment")
-- assert(nil, "description is not included in type comment")

assert(petstore.components.responses, "no responses found in mock API")

local responses = createLuauTypeFromOpenAPIObject(petstore.components.responses)

print(responses)
