-- local studio = settings().Studio
local function setStudioTheme(theme: { [string]: any }, studio: Studio)
	for name, color in theme do
		color = Color3.fromHex(color)

		local success = pcall(function()
			studio[name] = color
		end)

		if not success then
			warn(("%s is not a valid theme color"):format(name))
		end
	end

	return
end

return setStudioTheme
