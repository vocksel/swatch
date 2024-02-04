local fs = require("@lune/fs")
local serde = require("@lune/serde")
local openapiTypes = require("@server/openapi/openapi31")
local parseLuauType = require("./parseLuauType")

type OpenAPIObject = openapiTypes.OpenAPIObject

local petstore: OpenAPIObject = serde.decode("yaml", fs.readFile("server/src/openapi/mocks/petstore.yml"))

-- print(petstore)

assert(petstore.components.schemas, "no schemas found in mock API")

-- print("schemas", petstore.components.schemas)

local Pet = parseLuauType("Pet", petstore.components.schemas.Pet)
assert(Pet ~= nil, `failed to parse "Pet" schema`)
assert(Pet.name == "Pet", `bad Pet.name (expected string, got {Pet.name})`)
assert(Pet.body ~= nil, `missing Pet.body`)
assert(Pet.body.id == "number", `bad Pet.body.id (expected number, got {Pet.body.id})`)
assert(Pet.body.name == "string", `bad Pet.body.name (expected string, got {Pet.body.name})`)
assert(Pet.body.tag == "string?", `bad Pet.body.tag (expected string?, got {Pet.body.tag})`)

local Pets = parseLuauType("Pets", petstore.components.schemas.Pets)
assert(Pets ~= nil, `failed to parse "Pets" schema`)

local Error = parseLuauType("Error", petstore.components.schemas.Error)
assert(Error ~= nil, `failed to parse "Error" schema`)

-- assert(nil, "summary is not included in type comment")
-- assert(nil, "description is not included in type comment")
