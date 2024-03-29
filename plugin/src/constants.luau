return {
	PLUGIN_NAME = "Swatch",

	SERVER_URL = "https://swatch.vocksel.com",

	--[[
		This object maps Roblox Studio script editor colors to an array of
		VSCode's base colors, as well as token colors.

		See the Studio object for valid script editor colors.
		https://developer.roblox.com/en-us/api-reference/class/Studio

		When examining a theme's json file, there is a `colors` object, and a
		`tokenColors` array. Any key in the `colors` object can be used, and any
		of the scopes for the token's can be used.

		Precedence is left-to-right, so for example with "Text Color" if a match
		is found for `string.unquoted`, then `variable` will not be used.
	]]
	ROBLOX_VSCODE_THEME_MAP = {
		["Background Color"] = {
			"editor.background",
		},
		["Selection Color"] = {
			"foreground",
			"editor.foreground",
		},
		["Selection Background Color"] = {
			"editor.selectionBackground",
			"selection.background",
		},
		["Error Color"] = {
			"errorForeground",
			"editorError.foreground",
		},
		["Warning Color"] = {
			"editorWarning.foreground",
		},
		["Find Selection Background Color"] = {
			"editor.findMatchBackground",
		},
		["Matching Word Background Color"] = {
			"editor.selectionBackground",
		},
		["Whitespace Color"] = {
			"editorLineNumber.activeForeground",
		},
		["Current Line Highlight Color"] = {
			"editor.background",
		},
		["Ruler Color"] = {
			"editorRuler.foreground",
		},
		["Bracket Color"] = {
			"meta.brace",
			"foreground",
			"editor.foreground",
		},
		["Text Color"] = {
			"string.unquoted",
			"variable",
			"variable.object",
			"variable.other",
			"variable.parameter",
			"support",
		},
		["Operator Color"] = {
			"keyword.operator",
			"keyword",
		},
		["Number Color"] = {
			"constant.numeric",
			"constant",
		},
		["String Color"] = {
			"string",
			"string.quoted",
		},
		["Comment Color"] = {
			"comment",
		},
		["Bool Color"] = {
			"constant.language",
			"constant",
		},
		['"nil" Color'] = {
			"constant.language",
			"constant",
		},
		["Function Name Color"] = {
			"entity.name.function",
			"variable.function",
			"meta.function",
		},
		['"function" Color'] = {
			"keyword",
			"keyword.control",
			"variable",
			"variable.language",
			"meta.function",
		},
		['"local" Color'] = {
			"keyword",
		},
		['"self" Color'] = {
			"variable.instance",
			"variable.language",
			"support",
			"keyword",
			"variable",
		},
		["Luau Keyword Color"] = {
			"variable",
		},
		["Keyword Color"] = {
			"keyword",
		},
		["Built-in Function Color"] = {
			"support.function",
			"entity.name",
			"entity.other",
		},
		['"TODO" Color'] = {
			"variable",
			"keyword",
		},
		["Method Color"] = {
			"entity.name.function",
			"variable.function",
		},
		["Property Color"] = {
			"variable",
		},
	},
}
