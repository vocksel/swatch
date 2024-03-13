local React = require("@pkg/React")
local getLayoutOrder = require("./getLayoutOrder")
local TabButton = require("./TabButton")
local types = require("@root/types")

export type Props = {
	views: { types.View },
	onNavigate: (view: types.View) -> (),
}

local function NavBar(props: Props)
	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
		}),
	}

	for _, view in props.views do
		children[view] = React.createElement(TabButton, {
			LayoutOrder = getLayoutOrder(),
			text = view,
			width = UDim.new(1 / #props.views),
			onActivated = function()
				props.onNavigate(view)
			end,
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, children)
end

return NavBar
