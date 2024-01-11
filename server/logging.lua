local stdio = require("@lune/stdio")

type LogLevel = "info" | "warning" | "error" | "debug"

export type Logging = {
	print: typeof(print),
	logLevel: LogLevel,
	info: (message: string) -> (),
	warn: (message: string) -> (),
	err: (message: string) -> (),
	debug: (message: string) -> (),
}

local LOG_LEVEL_ORDER = {
	"info",
	"warning",
	"debug",
	"error",
}

local function isLogLevelValid(logLevel: string): boolean
	return table.find(LOG_LEVEL_ORDER, logLevel) ~= nil
end

local Logging = {}

function Logging.new(): Logging
	local self = {}

	self.print = print
	self.stdio = stdio
	self.logLevel = "info"

	local function shouldLog(logLevel: LogLevel): boolean
		local maxPriority = table.find(LOG_LEVEL_ORDER, self.logLevel)
		local priorityToCheck = table.find(LOG_LEVEL_ORDER, logLevel)

		if maxPriority and priorityToCheck then
			return priorityToCheck <= maxPriority
		else
			return false
		end
	end

	function self.setLogLevel(logLevel: string)
		logLevel = logLevel:lower()
		if isLogLevelValid(logLevel) then
			self.logLevel = logLevel
		end
	end

	function self.info(...)
		if shouldLog("info") then
			self.print(`[info]`, ...)
		end
	end

	function self.warn(...)
		if shouldLog("warn") then
			self.stdio.write(stdio.color("yellow"))
			self.print(`[warn]`, ...)
			self.stdio.write(stdio.color("reset"))
		end
	end

	function self.err(...)
		if shouldLog("error") then
			self.stdio.write(stdio.color("red"))
			self.print(`[err]`, ...)
			self.stdio.write(stdio.color("reset"))
		end
	end

	function self.debug(...)
		if shouldLog("debug") then
			self.print(`[debug]`, ...)
		end
	end

	return self
end

return Logging.new()
