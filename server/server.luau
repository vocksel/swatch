local process = require("@lune/process")
local net = require("@lune/net")

local getThemes = require("./routes/getThemes")

local PORT: string? = process.env.PORT or 8080

local routes = {
	[getThemes.route] = getThemes.callback,

	["/health"] = function()
		return {
			status = 200,
			body = "Healthy",
		}
	end,
}

net.serve(PORT, function(request)
	print(("%s %s"):format(request.method, request.path))

	for route, callback in routes do
		if request.path == route then
			local success, result = pcall(callback, request)

			if success then
				return result
			else
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
