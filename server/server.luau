local process = require("@lune/process")
local net = require("@lune/net")

local getThemes = require("./routes/getThemes")
local getExtensions = require("./routes/getExtensions")

local PORT: string? = process.env.PORT or 8080

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

net.serve(PORT, function(request)
	print(`{request.method} {request.path}`)

	for route, callback in routes do
		if request.path == route then
			local success, result = xpcall(function()
				return callback(request)
			end, debug.traceback)

			if success then
				return result
			else
				warn(`FAILED: {request.method} {request.path}`)
				warn(`err: {result}`)

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
print("Server started on port", PORT)
