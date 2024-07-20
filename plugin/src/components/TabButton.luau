local React = require("@pkg/React")
local Sift = require("@pkg/Sift")

local TEXT_SIZE = 16
local PADDING = 8
local BUTTON_TEXT_COLOR = Color3.fromRGB(0, 0, 0)
local BUTTON_COLOR = Color3.fromRGB(150, 150, 150)
local BUTTON_HOVER_COLOR = Color3.fromRGB(200, 200, 200)

local defaultProps = {
	width = UDim.new(1, 0),
}

export type Props = {
	text: string,
	width: UDim?,
	onActivated: (() -> ())?,
	LayoutOrder: number?,
}

type InternalProps = typeof(defaultProps) & Props

local function TabButton(providedProps: Props)
	local props: InternalProps = Sift.Dictionary.join(defaultProps, providedProps)
	local isHovered, setIsHovered = React.useState(false)

	local onMouseEnter = React.useCallback(function()
		setIsHovered(true)
	end, {})

	local onMouseLeave = React.useCallback(function()
		setIsHovered(false)
	end, {})

	return React.createElement("TextButton", {
		LayoutOrder = props.LayoutOrder,
		Text = props.text,
		TextColor3 = BUTTON_TEXT_COLOR,
		AutoButtonColor = false,
		TextSize = TEXT_SIZE,
		Font = Enum.Font.GothamMedium,
		Size = UDim2.new(props.width, UDim.new()),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = if isHovered then BUTTON_HOVER_COLOR else BUTTON_COLOR,
		BorderSizePixel = 0,
		[React.Event.MouseEnter] = onMouseEnter,
		[React.Event.MouseLeave] = onMouseLeave,
		[React.Event.Activated] = props.onActivated,
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, PADDING),
			PaddingBottom = UDim.new(0, PADDING),
		}),
	})
end

return TabButton
