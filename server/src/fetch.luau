local net = require("@lune/net")
local logging = require("./logging")
local createUrl = require("./createUrl")

local function fetch(payload)
	local method = if payload.method then payload.method else "GET"
	logging.debug(`{method} {createUrl(payload.url, payload.query)}`)
	if payload.body then
		logging.debug("body:", payload.body)
	end
	return net.request(payload)
end

return fetch
