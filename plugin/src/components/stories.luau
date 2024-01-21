local React = require("@pkg/React")
local getLayoutOrder = require("./getLayoutOrder")

type Story = {
	name: string?,
	story: (...any) -> Story,
}

local PADDING = 16

local function stories(storyList: { Story })
	return function(storyProps)
		local children = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, PADDING * 2),
			}),
		}

		for _, story in storyList do
			children[story.name] = React.createElement("Frame", {
				LayoutOrder = getLayoutOrder(),
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, PADDING),
				}),

				Header = React.createElement("TextLabel", {
					Text = story.name,
					LayoutOrder = getLayoutOrder(),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					TextSize = 16,
					Font = Enum.Font.GothamMedium,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextTruncate = Enum.TextTruncate.AtEnd,
				}),

				Divider = React.createElement("Frame", {
					LayoutOrder = getLayoutOrder(),
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = Color3.fromRGB(100, 100, 100),
					BackgroundTransparency = 0.5,
					BorderSizePixel = 0,
				}),

				StoryWrapper = React.createElement("Frame", {
					LayoutOrder = getLayoutOrder(),
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
				}, {
					Story = React.createElement(story.story, storyProps),
				}),
			})
		end

		return React.createElement("Frame", {
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
		}, children)
	end
end

return stories
