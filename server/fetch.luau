local net = require("@lune/net")

local function fetch(payload)
	local method = if payload.method then payload.method else "GET"
	print(`{method} {payload.url}`)
	return net.request(payload)
end

return fetch
