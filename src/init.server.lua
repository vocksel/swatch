local React = require(script.Packages.React)
local ReactRoblox = require(script.Packages.ReactRoblox)
local fetchVisualStudioExtensions = require(script.fetchVisualStudioExtensions)
local fetchExtensionThemes = require(script.fetchExtensionThemes)
local getThemeColors = require(script.getThemeColors)
local types = require(script.types)
local urls = require(script.urls)
local request = require(script.request)
local constants = require(script.constants)
local App = require(script.App)

local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 400, 400, 100, 100)
local container = plugin:CreateDockWidgetPluginGui(constants.PLUGIN_NAME, info)

local root = ReactRoblox.createRoot(container)
local element = React.createElement(App, {
	plugin = plugin,
})

root:render(element)

plugin.Unloading:Connect(function()
	root:unmount()
end)

do
	local success = request({
		url = `{urls.SERVER_URL}/health`,
		polling = {
			times = 5,
			seconds = 10,
		},
	}):await()

	if not success then
		warn("Failed to connect to server. Reload the experience to retry")
		return
	end
end

do
	print("Established connection to server")

	local success, themes = fetchVisualStudioExtensions({ searchTerm = "synthwave" })
		:andThen(function(extensions: { types.Extension })
			local extension = extensions[1]
			local latestVersion = extension.versions[1]

			assert(latestVersion, "No latest version found for extension {extension.displayName}")

			return fetchExtensionThemes(extension, latestVersion.version)
		end)
		:catch(function(err)
			warn("ERR:", err)
		end)
		:await()

	if success and themes then
		print("themes", themes)
		local theme = if #themes > 0 then themes[1] else nil

		if theme then
			local colors = getThemeColors(theme)

			if colors and colors.found then
				print("applying theme...")
				for name, color in colors.found do
					-- Discard the alpha component of the hexcode
					if #color - 1 > 6 then
						warn(`{name} uses unsupported alpha value`)
						color = color:sub(7, #color)
					end

					settings().Studio[name] = Color3.fromHex(color)
				end
			end
		end
	end
end
