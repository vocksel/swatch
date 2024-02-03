local process = require("@lune/process")
local net = require("@lune/net")
local fs = require("@lune/fs")
local serde = require("@lune/serde")

local getThemes = require("./routes/getThemes")
local getExtensions = require("./routes/getExtensions")
local logging = require("./logging")
local createUrl = require("./createUrl")
local dirname = require("./dirname")

local ADDRESS = process.env.ADDRESS or "http://0.0.0.0"
local PORT = tonumber(process.env.PORT) or 8080
local SCRIPT_DIR = dirname()
local API_SPEC = serde.encode("json", serde.decode("yaml", fs.readFile(`{SCRIPT_DIR}/api.yml`)))

local routes = {
	[getThemes.route] = getThemes.callback,
	[getExtensions.route] = getExtensions.callback,
	["/v1/health"] = function()
		return {
			status = 200,
			body = "Healthy",
		}
	end,
	["/api"] = function()
		return {
			status = 200,
			headers = {
				["Content-Type"] = "application/json",
				["Access-Control-Allow-Origin"] = "*",
			},
			body = API_SPEC,
		}
	end,
}

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
