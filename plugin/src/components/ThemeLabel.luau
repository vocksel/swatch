local React = require("@pkg/React")
local types = require("@root/types")
local getLayoutOrder = require("./getLayoutOrder")
local getThemeColors = require("@root/getThemeColors")

local useMemo = React.useMemo

local ACTION_BUTTON_WIDTH = 120
local PADDING = UDim.new(0, 8)
local NUM_PREVIEW_COLORS = 5

export type Props = {
	theme: types.ExtensionTheme,
	onApplyTheme: ((theme: types.ExtensionTheme) -> ())?,
	LayoutOrder: number?,
}

local function ThemeLabel(props: Props)
	local previewedColors = useMemo(function()
		local colors = getThemeColors(props.theme)
		local elements = {}
		local count = 0

		for _, colorCode in colors.found do
			local success, color = pcall(Color3.fromHex, colorCode)
			if success then
				elements[colorCode] = React.createElement("Frame", {
					LayoutOrder = count,
					BackgroundColor3 = color,
					Size = UDim2.fromOffset(32, 32),
					BorderSizePixel = 0,
				}, {
					BorderRadius = React.createElement("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				})

				count += 1
				if count == NUM_PREVIEW_COLORS then
					break
				end
			end
		end

		for i = 1, NUM_PREVIEW_COLORS do
			local color = colors.found[i]

			if color then
				elements[tostring(color)] = React.createElement("Frame", {
					LayoutOrder = i,
					BackgroundColor3 = color,
					Size = UDim2.fromOffset(32, 32),
					BorderSizePixel = 0,
				})
			end
		end

		return elements
	end, { props.theme })

	return React.createElement("Frame", {
		LayoutOrder = props.LayoutOrder,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),

		Padding = React.createElement("UIPadding", {
			PaddingTop = PADDING,
			PaddingRight = PADDING,
			PaddingBottom = PADDING,
			PaddingLeft = PADDING,
		}),

		Main = React.createElement("Frame", {
			LayoutOrder = getLayoutOrder(),
			Size = UDim2.fromScale(1, 0) - UDim2.fromOffset(ACTION_BUTTON_WIDTH, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = PADDING,
			}),

			Name = React.createElement("TextLabel", {
				LayoutOrder = getLayoutOrder(),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Text = props.theme.name,
				TextSize = 16,
				Font = Enum.Font.GothamMedium,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTruncate = Enum.TextTruncate.AtEnd,
			}),

			Colors = React.createElement("Frame", {
				LayoutOrder = getLayoutOrder(),
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = PADDING,
				}),

				PreviewColors = React.createElement(React.Fragment, {}, previewedColors),
			}),
		}),

		Action = React.createElement("TextButton", {
			LayoutOrder = getLayoutOrder(),
			Text = "Use Theme",
			TextSize = 14,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			Font = Enum.Font.GothamMedium,
			Size = UDim2.fromOffset(ACTION_BUTTON_WIDTH, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.fromRGB(143, 186, 86),
			[React.Event.Activated] = function()
				if props.onApplyTheme then
					props.onApplyTheme(props.theme)
				end
			end,
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = PADDING,
				PaddingRight = PADDING,
				PaddingBottom = PADDING,
				PaddingLeft = PADDING,
			}),

			Corner = React.createElement("UICorner", {
				CornerRadius = PADDING,
			}),
		}),
	})
end

return ThemeLabel
