local Root = script:FindFirstAncestor("rbxtheme")

local React = require(Root.Packages.React)
local Sift = require(Root.Packages.Sift)

local useClock = require(Root.Components.useClock)

export type Props = {
	speed: number?,
	Size: UDim2?,
}

local defaultProps = {
	speed = 1,
	Size = UDim2.fromOffset(64, 64),
}

local SPEED_MULTIPLIER = 200

type InternalProps = Props & typeof(defaultProps)

local function LoadingSpinner(providedProps: Props)
	local props: InternalProps = Sift.Dictionary.join(defaultProps, providedProps)
	local clock = useClock()

	return React.createElement("Frame", {
		Size = props.Size,
		BackgroundTransparency = 1,
	}, {
		Spinner = React.createElement("ImageLabel", {
			Image = "rbxasset://textures/DarkThemeLoadingCircle.png",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Rotation = clock:map(function(n)
				return n * (props.speed * SPEED_MULTIPLIER)
			end),
		}),
	})
end

return LoadingSpinner
