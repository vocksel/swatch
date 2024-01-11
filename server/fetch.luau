local net = require("@lune/net")
local logging = require("./logging")

local function fetch(payload)
	local method = if payload.method then payload.method else "GET"
	logging.debug(`{method} {payload.url}`)
	return net.request(payload)
end

return fetch
