local React = require("@pkg/React")

local useCallback = React.useCallback

local PADDING = UDim.new(0, 8)

export type Props = {
	searchTerm: string?,
	onSearch: (searchTerm: string) -> (),
	LayoutOrder: number?,
}

local function Searchbar(props: Props)
	local onSearch = useCallback(function(rbx: TextBox, enterPressed: boolean)
		if enterPressed and rbx.Text ~= "" then
			props.onSearch(rbx.Text)
		end
	end, { props.onSearch })

	return React.createElement("Frame", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {
		Input = React.createElement("TextBox", {
			Text = if props.searchTerm then props.searchTerm else "",
			PlaceholderText = "Search themes...",
			Size = UDim2.fromScale(1, 0),
			TextColor3 = Color3.fromRGB(255, 255, 255),
			PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
			TextSize = 16,
			Font = Enum.Font.Gotham,
			AutomaticSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(100, 100, 100),
			[React.Event.FocusLost] = onSearch,
		}, {
			BorderRadius = React.createElement("UICorner", {
				CornerRadius = PADDING,
			}),

			Padding = React.createElement("UIPadding", {
				PaddingTop = PADDING,
				PaddingRight = PADDING,
				PaddingBottom = PADDING,
				PaddingLeft = PADDING,
			}),
		}),
	})
end

return Searchbar
