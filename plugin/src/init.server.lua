local React = require(script.Packages.React)
local ReactRoblox = require(script.Packages.ReactRoblox)
local constants = require(script.constants)
local App = require(script.Components.App)

local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 400, 400, 100, 100)
local widget = plugin:CreateDockWidgetPluginGui(constants.PLUGIN_NAME, info)
widget.Name = constants.PLUGIN_NAME
widget.Title = widget.Name
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local toolbar = plugin:CreateToolbar(constants.PLUGIN_NAME)
local button = toolbar:CreateButton(
	widget.Name,
	"View Themes",
	"" -- TODO: Add an icon
)

local root = ReactRoblox.createRoot(widget)
local app = React.createElement(App, {
	plugin = plugin,
})

local clickConn = button.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

local function update()
	button:SetActive(widget.Enabled)

	if widget.Enabled then
		root:render(app)
	else
		root:unmount()
	end
end

local widgetConn = widget:GetPropertyChangedSignal("Enabled"):Connect(update)

update()

plugin.Unloading:Connect(function()
	widgetConn:Disconnect()
	clickConn:Disconnect()
	root:unmount()
end)
