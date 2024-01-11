local process = require("@lune/process")
local net = require("@lune/net")

local getThemes = require("./routes/getThemes")
local getExtensions = require("./routes/getExtensions")
local logging = require("./logging")

local PORT: string? = process.env.PORT or 8080
local LOG_LEVEL: string? = process.env.LOG_LEVEL

local routes = {
	[getThemes.route] = getThemes.callback,
	[getExtensions.route] = getExtensions.callback,
	["/health"] = function()
		return {
			status = 200,
			body = "Healthy",
		}
	end,
}

if LOG_LEVEL then
	logging.setLogLevel(LOG_LEVEL)
end

net.serve(PORT, function(request)
	logging.debug(`{request.method} {request.path}`)

	for route, callback in routes do
		if request.path == route then
			local success, result = xpcall(function()
				return callback(request)
			end, debug.traceback)

			if success then
				return result
			else
				logging.warn(`FAILED: {request.method} {request.path}\n{result}`)

				return {
					status = 500,
					body = result,
				}
			end
		end
	end

	return {
		status = 404,
		body = "Not Found",
	}
end)
logging.info("server started on port", PORT)
