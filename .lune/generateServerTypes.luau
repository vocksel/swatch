local fs = require("@lune/fs")
local serde = require("@lune/serde")
local openapi = require("@server/openapi")

local API_SPEC = serde.decode("yaml", fs.readFile(`server/src/api.yml`))

print(openapi.generateApiTypes(API_SPEC))
