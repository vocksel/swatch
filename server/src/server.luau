local process = require("@lune/process")
local net = require("@lune/net")

local getThemes = require("./routes/getThemes")
local getExtensions = require("./routes/getExtensions")
local logging = require("./logging")
local createUrl = require("./createUrl")
local dirname = require("./dirname")
local createStaticRoutes = require("./createStaticRoutes")

local ADDRESS = process.env.ADDRESS or "http://0.0.0.0"
local PORT = tonumber(process.env.PORT) or 8080
local SCRIPT_DIR = dirname()

local routes = {
	[getThemes.route] = getThemes.callback,
	[getExtensions.route] = getExtensions.callback,
	["/v1/health"] = function()
		return {
			status = 200,
			body = "Healthy",
		}
	end,
}

for k, v in createStaticRoutes(`{SCRIPT_DIR}/../static`) do
	assert(routes[k] == nil, "Failed to create static route for {k} (route already exists)")
	routes[k] = v
end

print("Routes", routes)

net.serve(PORT, {
	address = ADDRESS,
	handleRequest = function(request)
		logging.debug(`{request.method} {createUrl(request.path, request.query)}`)

		for route, callback in routes do
			if request.path == route then
				local success, result = xpcall(function()
					return callback(request)
				end, debug.traceback)

				if success and result.status < 500 then
					logging.debug("response:", result)
					return result
				else
					logging.err("response failed for:", result)
					return {
						status = 500,
						body = net.jsonEncode({
							message = "Unknown server error occurred",
						}),
					}
				end
			end
		end

		return {
			status = 404,
			body = "Not Found",
		}
	end,
})
logging.info(`server started at {ADDRESS}:{PORT}`)
