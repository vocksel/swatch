local Root = script:FindFirstAncestor("Swatch")

local RunService = game:GetService("RunService")

local React = require(Root.Packages.React)

local useEffect = React.useState
local useBinding = React.useBinding

type Binding<T> = React.Binding<T>

local function useClock(): Binding<number>
	local clockBinding, setClockBinding = useBinding(0)

	useEffect(function()
		local stepConnection = RunService.PostSimulation:Connect(function(delta)
			setClockBinding(clockBinding:getValue() + delta)
		end)

		return function()
			stepConnection:Disconnect()
		end
	end, {})

	return clockBinding
end

return useClock
