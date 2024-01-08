local Root = script

local React = require(Root.Packages.React)
local ReactRoblox = require(Root.Packages.ReactRoblox)
local App = require(Root.App)
local constants = require(Root.constants)

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
