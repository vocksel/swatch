-- upstream: https://github.com/vocksel/rbxtheme/blob/main/src/theme/getThemeColors.js

local Root = script:FindFirstAncestor("rbxtheme")

local Sift = require(Root.Packages.Sift)
local constants = require(Root.constants)
local getScopeColors = require(Root.getScopeColors)

local function getThemeColors(theme): {
	found: { [string]: Color3 },
	missing: { string },
}
	local found = {}
	local missing = {}

	for studioName, vscodeColors in constants.ROBLOX_VSCODE_THEME_MAP do
		local color: Color3

		for _, vscodeColor in vscodeColors do
			-- TODO: Some default themes like Dark+ have an "include" field, which
			-- points to another theme files. Add support for that.

			if theme.colors then
				color = theme.colors[vscodeColor]
			end

			if not color then
				-- The color doesn't exist in the root list of theme colors.
				-- Let's look through the tokenColors array.
				local scopeColors = getScopeColors(theme)
				color = scopeColors[vscodeColor]
			end

			-- Ok, not there either. Does the theme have global colors?
			if not color then
				local global = Sift.Array.findWhere(theme.tokenColors, function(token)
					return token.scope == nil
				end)

				if global then
					color = global.settings.foreground
				end
			end

			if color then
				break
			end
		end

		if color then
			found[studioName] = color
		else
			table.insert(missing, studioName)
		end
	end

	return {
		found = found,
		missing = missing,
	}
end

return getThemeColors