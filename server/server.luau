local process = require("@lune/process")
local fs = require("@lune/fs")
local net = require("@lune/net")

local PORT: string? = process.env.PORT or 8080

local MARKETPLACE_APIS_URL = "https://marketplace.visualstudio.com/_apis"

-- local response = net.request({
-- 	url = "https://dummyjson.com/products/add",
-- 	method = "POST",
-- 	headers = {
-- 		["Content-Type"] = "application/json"
-- 	},
-- 	body = net.jsonEncode({
-- 		title = "Cool Pencil",
-- 	}),
-- })

local routes = {
	["/get-themes"] = function(request)
		local publisherName = request.query.publisherName
		local extensionName = request.query.extensionName
		local extensionVersion = request.query.extensionVersion

		local res = net.request({
			method = "GET",
			url = ("%s/public/gallery/publishers/%s/vsextensions/%s/%s/vspackage"):format(
				MARKETPLACE_APIS_URL,
				publisherName,
				extensionName,
				extensionVersion
			),
		})

		-- save res.body to a file
		-- unzip
		-- find which themes it exports
		-- return each theme json

		local extensionFilename = ("%s-%s-%s"):format(publisherName, extensionName, extensionVersion)

		print(res.body)

		if res.ok then
			local extensionZipFilename = ("%s.zip"):format(extensionFilename)
			fs.writeFile(extensionZipFilename, res.body)

			local result = process.spawn("unzip", {
				extensionZipFilename,
				"-d",
				"extension",
			})

			print(result)

			return {
				status = 200,
			}
		else
			return res
		end
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
