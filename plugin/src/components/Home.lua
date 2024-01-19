local React = require("@pkg/React")
local fetchVisualStudioExtensions = require("@root/fetchVisualStudioExtensions")
local types = require("@root/types")
local LoadingSpinner = require("./LoadingSpinner")
local ExtensionsList = require("./ExtensionsList")
local getLayoutOrder = require("./getLayoutOrder")

type PublishedExtension = types.PublishedExtension
type ExtensionTheme = types.ExtensionTheme

local useCallback = React.useCallback
local useEffect = React.useEffect
local useState = React.useState

local PADDING = UDim.new(0, 8)

export type Props = {
	onViewExtension: (extension: PublishedExtension) -> (),
}

local function Home(props: Props)
	local isLoading, setIsLoading = useState(true)
	local extensions, setExtensions = useState({} :: { PublishedExtension })
	local searchTerm, setSearchTerm = useState("")
	local err, setErr = useState(nil :: string?)

	local onSearch = useCallback(function(rbx: TextBox, enterPressed: boolean)
		if enterPressed then
			setSearchTerm(rbx.Text)
		end
	end, {})

	useEffect(function()
		setErr(nil)
		setIsLoading(true)
		fetchVisualStudioExtensions({
				-- page = page, -- TODO: Increment the page when scrolling to the bottom of the list
				pageSize = 20,
				searchTerm = if searchTerm ~= "" then searchTerm else "theme",
			})
			:andThen(function(newExtensions)
				setExtensions(newExtensions)
			end)
			:catch(function()
				setErr(`No extensions found. Please try again later`)
			end)
			:finally(function()
				setIsLoading(false)
			end)
	end, { searchTerm })

	return React.createElement("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		CanvasSize = UDim2.fromScale(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
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

		SearchForm = React.createElement("Frame", {
			LayoutOrder = getLayoutOrder(),
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		}, {
			Input = React.createElement("TextBox", {
				Text = searchTerm,
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
				Padding = React.createElement("UIPadding", {
					PaddingTop = PADDING,
					PaddingRight = PADDING,
					PaddingBottom = PADDING,
					PaddingLeft = PADDING,
				}),
			}),
		}),

		ErrorMessage = if err
			then React.createElement("TextLabel", {
				LayoutOrder = getLayoutOrder(),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				Text = err,
				TextSize = 16,
				Font = Enum.Font.GothamMedium,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextTruncate = Enum.TextTruncate.AtEnd,
			})
			else nil,

		ExtensionsListWrapper = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = getLayoutOrder(),
			},
			if isLoading
				then {
					Layout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
					}),

					LoadingSpinner = React.createElement(LoadingSpinner),
				}
				else {
					ExtensionList = if not isLoading
						then React.createElement(ExtensionsList, {
							extensions = extensions,
							onView = props.onViewExtension,
						})
						else nil,
				}
		),
	})
end

return Home
