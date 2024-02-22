local fs = require("@lune/fs")

type RouteFn = () -> {
	status: number,
	body: any,
}

local function createStaticRoutes(startPath: string): { [string]: RouteFn }
	assert(fs.isDir(startPath), `start path must be a directory: {startPath}`)
	local routes = {}

	local function recurse(currentPath: string)
		for _, fileName in fs.readDir(currentPath) do
			local filePath = `{currentPath}/{fileName}`
			if fs.isFile(filePath) then
				local content = fs.readFile(filePath)
				local shortPath = filePath:gsub(startPath, "")

				routes[shortPath] = function()
					return {
						status = 200,
						headers = {
							["Access-Control-Allow-Origin"] = "*",
						},
						body = content,
					}
				end
			else
				recurse(filePath)
			end
		end
	end

	recurse(startPath)

	return routes
end

return createStaticRoutes
