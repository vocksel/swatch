local styles = {}

local BODY_TEXT_COLOR = Color3.fromHex("#ffffff")
local BODY_TEXT_SIZE = 16
local BODY_TEXT_FONT = Enum.Font.GothamMedium

styles.text = {
	Text = "",
	Size = UDim2.fromScale(0, 0),
	AutomaticSize = Enum.AutomaticSize.XY,
	TextColor3 = BODY_TEXT_COLOR,
	TextSize = BODY_TEXT_SIZE,
	Font = BODY_TEXT_FONT,
	BackgroundTransparency = 1,
}

return styles
