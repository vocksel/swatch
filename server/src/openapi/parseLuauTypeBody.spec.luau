local fs = require("@lune/fs")
local serde = require("@lune/serde")
local openapiTypes = require("@server/openapi/openapi31")
local parseLuauTypeBody = require("./parseLuauTypeBody")

type OpenAPIObject = openapiTypes.OpenAPIObject

local petstore: OpenAPIObject = serde.decode("yaml", fs.readFile("server/src/openapi/mocks/petstore.yml"))

local body = parseLuauTypeBody(petstore.components.schemas.Pet)
assert(body ~= nil, `bad body (expected table, got {body})`)
assert(body.id == "number", `bad body.id (expected number, got {body.id})`)
assert(body.name == "string", `bad body.name (expected string, got {body.name})`)
assert(body.tag == "string?", `bad body.tag (expected string?, got {body.tag})`)

body = parseLuauTypeBody(petstore.components.schemas.Pets)
assert(body ~= nil, `bad body (expected table, got {body})`)
