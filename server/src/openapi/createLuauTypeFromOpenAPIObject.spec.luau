local fs = require("@lune/fs")
local serde = require("@lune/serde")
local openapiTypes = require("@server/openapi/openapi31")
local createLuauTypeFromOpenAPIObject = require("./createLuauTypeFromOpenAPIObject")

type OpenAPIObject = openapiTypes.OpenAPIObject

local petstore: OpenAPIObject = serde.decode("yaml", fs.readFile("server/src/openapi/mocks/petstore.yml"))

-- print(petstore)

assert(petstore.components.schemas, "no schemas found in mock API")

-- print("schemas", petstore.components.schemas)

local Pet = createLuauTypeFromOpenAPIObject(petstore.components.schemas.Pet)
assert(Pet ~= nil, `missing "Pet" schema`)
assert(Pet.id == "number", `bad Pet.id (expected number, got {Pet.id})`)
assert(Pet.name == "string", `bad Pet.name (expected string, got {Pet.name})`)
assert(Pet.tag == "string?", `bad Pet.tag (expected string?, got {Pet.tag})`)

local Pets = createLuauTypeFromOpenAPIObject(petstore.components.schemas.Pets)
assert(Pets ~= nil, `missing "Pets" schema`)
assert(Pets.id == "number", `bad Pets.id (expected number, got {Pets.id})`)
assert(Pets.name == "string", `bad Pets.name (expected string, got {Pets.name})`)
assert(Pets.tag == "string?", `bad Pets.tag (expected string?, got {Pets.tag})`)

local Error = createLuauTypeFromOpenAPIObject(petstore.components.schemas.Error)
assert(Error, `missing "Error" schema`)

-- assert(nil, "summary is not included in type comment")
-- assert(nil, "description is not included in type comment")

assert(petstore.components.responses, "no responses found in mock API")

local responses = createLuauTypeFromOpenAPIObject(petstore.components.responses)

print(responses)
