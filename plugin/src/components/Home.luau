local React = require("@pkg/React")
local types = require("@root/types")
local LoadingSpinner = require("./LoadingSpinner")
local ExtensionsList = require("./ExtensionsList")
local Searchbar = require("./Searchbar")
local getLayoutOrder = require("./getLayoutOrder")
local useCombinedSize = require("./useCombinedSize")

type PublishedExtension = types.PublishedExtension

local useMemo = React.useMemo

local PADDING = UDim.new(0, 8)

export type Props = {
	extensions: { PublishedExtension },
	onSearch: (searchTerm: string) -> (),
	onViewExtension: (extension: PublishedExtension) -> (),
	onFetchMore: (() -> ())?,
	searchTerm: string?,
	err: string?,
}

local function Home(props: Props)
	local isLoading: boolean = useMemo(function()
		return #props.extensions == 0 and not props.err
	end, { props.extensions, props.err })

	local combinedSize = useCombinedSize()

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

		SearchbarWrapper = React.createElement("Frame", {
			LayoutOrder = getLayoutOrder(),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			[React.Tag] = combinedSize.tag,
		}, {
			Searchbar = React.createElement(Searchbar, {
				searchTerm = props.searchTerm,
				onSearch = props.onSearch,
			}),
		}),

		ErrorMessage = if props.err
			then React.createElement("TextLabel", {
				LayoutOrder = getLayoutOrder(),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Text = props.err,
				TextSize = 16,
				Font = Enum.Font.GothamMedium,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTruncate = Enum.TextTruncate.AtEnd,
			})
			else nil,

		ExtensionsListWrapper = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1) - combinedSize.height,
			BackgroundTransparency = 1,
			LayoutOrder = getLayoutOrder(),
		}, {
			ExtensionList = React.createElement(ExtensionsList, {
				extensions = props.extensions,
				onScrollToBottom = props.onFetchMore,
				onView = props.onViewExtension,
			}),
		}),

		Loading = if isLoading
			then React.createElement("Frame", {
				LayoutOrder = getLayoutOrder(),
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				[React.Tag] = combinedSize.tag,
			}, {
				Layout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),

				LoadingSpinner = React.createElement(LoadingSpinner),
			})
			else nil,
	})
end

return Home
