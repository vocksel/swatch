local fs = require("@lune/fs")
local serde = require("@lune/serde")
local openapiTypes = require("@server/openapi/openapi31")
local createLuauComment = require("./createLuauComment")

type OpenAPIObject = openapiTypes.OpenAPIObject

local api: OpenAPIObject = serde.decode("yaml", fs.readFile("server/src/openapi/mocks/commented-schema.yml"))

local comment = createLuauComment(api.components.schemas.SummaryAndDescription)
local expected = [[-- A short summary
--
-- A long-form description of the schema]]

assert(comment, "no comment created")
assert(comment == expected, "comment doesn't match expectation\ncomment: {comment}\nexpected: {expected}")

comment = createLuauComment(api.components.schemas.SummaryOnly)
expected = "-- A short summary"

assert(comment, "no comment created")
assert(comment == expected, "comment doesn't match expectation\ncomment: {comment}\nexpected: {expected}")

comment = createLuauComment(api.components.schemas.DescriptionOnly)
expected = "-- A long-form description of the schema"

assert(comment, "no comment created")
assert(comment == expected, "comment doesn't match expectation\ncomment: {comment}\nexpected: {expected}")

comment = createLuauComment(api.components.schemas.Empty)
assert(comment == nil, "a comment was created when it shouldn't have been")
