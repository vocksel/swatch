local getThemeColors = require("@root/getThemeColors")
local types = require("@root/types")

local function applyTheme(theme: types.ExtensionTheme, studio: Studio): string?
	local colors = getThemeColors(theme)
	local problems = {}

	if colors and colors.found then
		for name, color in colors.found do
			-- Discard the alpha component of the hexcode
			if #color - 1 > 6 then
				local colorNoAlpha = color:sub(1, 7)

				-- TODO: Blend colors with the background to get rid of the
				-- alpha component. That way we don't need to warn the user
				table.insert(problems, `{name} uses unsupported alpha value. Truncating {color} to {colorNoAlpha}`)

				color = colorNoAlpha
			end

			local success, result = pcall(function()
				-- Casting to `any` to clear dynamic property access warning
				-- since we're already in a pcall
				(studio :: any)[name] = Color3.fromHex(color)
			end)

			if not success then
				table.insert(problems, `Failed to set {name}: {result}`)
			end
		end
	end

	if #problems > 0 then
		local problemsStr = ""
		for index, problem in problems do
			problemsStr ..= `{index}. {problem}\n`
		end
		return `{theme.name} was applied, but not all colors were set:\n{problemsStr}`
	end

	return nil
end

return applyTheme
