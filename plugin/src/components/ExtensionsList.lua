local Root = script:FindFirstAncestor("rbxtheme")

local React = require(Root.Packages.React)
local types = require(Root.types)
local getLayoutOrder = require(Root.Components.getLayoutOrder)

type PublishedExtension = types.PublishedExtension

export type Props = {
	extensions: { PublishedExtension },
	onView: (extension: PublishedExtension) -> (),
	LayoutOrder: number?,
}

local ACTION_BUTTON_WIDTH = 120
local PADDING = UDim.new(0, 8)

local function ExtensionsList(props: Props)
	local children = {
		Layout = React.createElement("UIListLayout", {
			Padding = PADDING,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	}

	for i, extension in props.extensions do
		local isEven = i % 2 == 0
		local latestVersion = if extension.versions then extension.versions[1] else nil

		children[extension.extensionName] = React.createElement("Frame", {
			LayoutOrder = i,
			BackgroundTransparency = if isEven then 1 else 0.2,
			BackgroundColor3 = Color3.fromRGB(100, 100, 100),
			BorderSizePixel = 0,
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
					Text = `{extension.displayName} v{latestVersion.version}`,
					TextSize = 16,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextTruncate = Enum.TextTruncate.AtEnd,
				}),

				Publisher = React.createElement("TextLabel", {
					LayoutOrder = getLayoutOrder(),
					Text = extension.publisher.publisherName,
					TextSize = 14,
					TextColor3 = Color3.fromRGB(200, 200, 200),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
				}),
			}),

			Action = React.createElement("TextButton", {
				LayoutOrder = getLayoutOrder(),
				Text = "View",
				TextSize = 14,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BorderSizePixel = 0,
				Font = Enum.Font.GothamMedium,
				Size = UDim2.fromOffset(ACTION_BUTTON_WIDTH, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				[React.Event.Activated] = function()
					props.onView(extension)
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

	return React.createElement("Frame", {
		LayoutOrder = props.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
	}, children)
end

return ExtensionsList
