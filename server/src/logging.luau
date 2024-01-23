local process = require("@lune/process")
local stdio = require("@lune/stdio")

type LogLevel = "info" | "warning" | "error" | "debug"

local LOG_LEVEL: string? = if process.env.LOG_LEVEL then process.env.LOG_LEVEL:lower() else "info"

local LOG_LEVEL_ORDER = {
	"error",
	"info",
	"warning",
	"debug",
}

local function canLog(logLevelToCheck: LogLevel): boolean
	local maxPriority = table.find(LOG_LEVEL_ORDER, LOG_LEVEL)
	local priorityToCheck = table.find(LOG_LEVEL_ORDER, logLevelToCheck)

	if maxPriority and priorityToCheck then
		return priorityToCheck <= maxPriority
	else
		return false
	end
end

local logging = {}

function logging.info(...)
	if canLog("info") then
		print(`[info]`, ...)
	end
end

function logging.warn(...)
	if canLog("warning") then
		stdio.write(stdio.color("yellow"))
		print(`[warn]`, ...)
		stdio.write(stdio.color("reset"))
	end
end

function logging.err(...)
	if canLog("error") then
		stdio.write(stdio.color("red"))
		print(`[err]`, ...)
		stdio.write(stdio.color("reset"))
	end
end

function logging.debug(...)
	if canLog("debug") then
		print(`[debug]`, ...)
	end
end

return logging
