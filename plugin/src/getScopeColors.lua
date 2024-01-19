-- upstream: https://github.com/vocksel/Swatch/blob/main/src/theme/getScopeColors.js

local Sift = require("@pkg/Sift")

local function getScopeColors(theme): { [string]: string }
	local colors = {}

	for _, token in theme.tokenColors do
		local color = token.settings.foreground

		if color then
			-- The token scope can either be an array of strings or a string. In
			-- some older themes, the scope can be a comma separated string
			-- denoting the list of scopes, so we have to handle both cases
			-- where the scope string is either a single scope, or many.
			local scopes = {}
			if token.scope then
				if Sift.Array.is(token.scope) then
					scopes = token.scope
				else
					scopes = token.scope:split(",")
				end
			end

			for _, scope in scopes do
				colors[scope] = color
			end
		end
	end

	return colors
end

return getScopeColors
