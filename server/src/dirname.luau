local process = require("@lune/process")

local function dirname()
	local info = debug.info(2, "s")
	local dir = info:match(`"(.*)/.*"]$`)
	local fullPath = `{process.cwd}/{dir}`

	return fullPath
		-- Collapse duplicate slashes to a single one
		:gsub("/+", "/")
		-- Remove trailing slash
		:gsub("/$", "")
end

return dirname
