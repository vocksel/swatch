local React = require("@pkg/React")
local usePrevious = require("./usePrevious")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useState = React.useState
local useRef = React.useRef

local function useScreen(ancestor: Instance?): LayerCollector?
	local screen: LayerCollector?, setScreen = useState(nil :: LayerCollector?)

	useEffect(function()
		if ancestor then
			setScreen(ancestor:FindFirstAncestorWhichIsA("LayerCollector"))
		end
	end, { ancestor })

	return screen
end

export type Props = {
	onTrigger: () -> (),
	LayoutOrder: number?,
}

local function ViewportTrigger(props: Props)
	local ref: { current: Frame? } = useRef()
	local screen = useScreen(ref.current)
	local position: Vector2, setPosition = useState(Vector2.zero)

	local onPositionChange = useCallback(function(rbx: Frame)
		setPosition(rbx.AbsolutePosition)
	end, {})

	local isInBounds = useMemo(function()
		if screen then
			if
				position.X > screen.AbsolutePosition.X
				and position.X < screen.AbsolutePosition.X + screen.AbsoluteSize.X
				and position.Y > screen.AbsolutePosition.Y
				and position.Y < screen.AbsolutePosition.Y + screen.AbsoluteSize.Y
			then
				return true
			end
		end
		return false
	end, { position, screen })

	local wasInBounds = usePrevious(isInBounds)

	useEffect(function()
		if isInBounds and not wasInBounds then
			props.onTrigger()
		end
	end, { isInBounds })

	return React.createElement("Frame", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromOffset(1, 1),
		BackgroundTransparency = 1,
		ref = ref,
		[React.Change.AbsolutePosition] = onPositionChange,
	})
end

return ViewportTrigger
