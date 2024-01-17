local Root = script:FindFirstAncestor("Swatch")

local React = require(Root.Packages.React)
local Sift = require(Root.Packages.Sift)
local types = require(Root.types)
local applyTheme = require(Root.applyTheme)
local getLayoutOrder = require(Root.Components.getLayoutOrder)

local useCallback = React.useCallback

local ACTION_BUTTON_WIDTH = 120
local PADDING = UDim.new(0, 8)

export type Props = {
	extension: types.PublishedExtension,
	themes: { types.ExtensionTheme },
	onBack: () -> (),
	studio: Studio?,
}

local defaultProps = {
	studio = settings().Studio,
}

type InternalProps = Props & typeof(defaultProps)

local function getThemeKey(theme: types.ExtensionTheme)
	return theme.uuid or theme.name or tostring(theme)
end

local function ThemeDetails(providedProps: Props)
	local props: InternalProps = Sift.Dictionary.join(defaultProps, providedProps)

	local latestVersion = if props.extension.versions then props.extension.versions[1] else nil
	local themeVariants = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = PADDING,
		}),
	}

	-- TODO: After applying a theme, ask if the user want's to switch their
	-- Studio theme (dark/light) to match
	local onApplyTheme = useCallback(function(theme: types.ExtensionTheme)
		local err = applyTheme(theme, props.studio)
		if err then
			warn(err)
		end
	end, {})

	for i, theme in props.themes do
		local key = getThemeKey(theme)
		local isEven = i % 2 == 0

		themeVariants[key] = React.createElement("Frame", {
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
					Text = theme.name,
					TextSize = 16,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextTruncate = Enum.TextTruncate.AtEnd,
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
					onApplyTheme(theme)
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
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = PADDING,
		}),

		Padding = React.createElement("UIPadding", {
			PaddingTop = PADDING,
			PaddingRight = PADDING,
			PaddingBottom = PADDING,
			PaddingLeft = PADDING,
		}),

		Back = React.createElement("TextButton", {
			LayoutOrder = getLayoutOrder(),
			Text = "< Back",
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			TextSize = 16,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextTruncate = Enum.TextTruncate.AtEnd,
			[React.Event.Activated] = props.onBack,
		}),

		Header = React.createElement("Frame", {
			LayoutOrder = getLayoutOrder(),
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = PADDING,
			}),

			Primary = React.createElement("Frame", {
				LayoutOrder = getLayoutOrder(),
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = PADDING,
				}),

				Name = React.createElement("TextLabel", {
					LayoutOrder = getLayoutOrder(),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					Text = props.extension.displayName,
					TextSize = 16,
					Font = Enum.Font.Gotham,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextTruncate = Enum.TextTruncate.AtEnd,
				}),

				Version = if latestVersion
					then React.createElement("TextLabel", {
						LayoutOrder = getLayoutOrder(),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						Text = `v{latestVersion.version}`,
						TextSize = 16,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextTruncate = Enum.TextTruncate.AtEnd,
					})
					else nil,
			}),

			Publisher = React.createElement("TextLabel", {
				LayoutOrder = getLayoutOrder(),
				Text = props.extension.publisher.publisherName,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(200, 200, 200),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Font = Enum.Font.Gotham,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			}),
		}),

		Variants = React.createElement("Frame", {
			LayoutOrder = getLayoutOrder(),
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
		}, themeVariants),
	})
end

return ThemeDetails
