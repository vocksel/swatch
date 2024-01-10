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
			return callback(request)
		end
	end

	return {
		status = 200,
		body = "Echo:\n" .. request.body,
	}
end)
print("Server started on port", PORT)
