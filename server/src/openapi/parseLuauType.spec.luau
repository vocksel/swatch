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
assert(Pet ~= nil, `missing "Pet" schema`)
assert(Pet.body ~= nil, `bad Pet.body (expected table, got {Pet.body})`)
assert(Pet.body.id == "number", `bad Pet.body.id (expected number, got {Pet.body.id})`)
assert(Pet.body.name == "string", `bad Pet.body.name (expected string, got {Pet.body.name})`)
assert(Pet.body.tag == "string?", `bad Pet.body.tag (expected string?, got {Pet.body.tag})`)

local Pets = parseLuauType("Pets", petstore.components.schemas.Pets)
assert(Pets ~= nil, `missing "Pets" schema`)
assert(Pets.id == "number", `bad Pets.id (expected number, got {Pets.id})`)
assert(Pets.name == "string", `bad Pets.name (expected string, got {Pets.name})`)
assert(Pets.tag == "string?", `bad Pets.tag (expected string?, got {Pets.tag})`)

local Error = parseLuauType("Error", petstore.components.schemas.Error)
assert(Error, `missing "Error" schema`)

-- assert(nil, "summary is not included in type comment")
-- assert(nil, "description is not included in type comment")
