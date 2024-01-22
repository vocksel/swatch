local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local React = require("@pkg/React")
local Sift = require("@pkg/Sift")
local useEvent = require("./useEvent")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useState = React.useState

type SizeMap = {
	[string]: number,
}

local function useCombinedSize()
	local sizeMap: SizeMap, setSizeMap = useState({} :: SizeMap)
	local tag = useMemo(function()
		local guid = HttpService:GenerateGUID()
		return `combined-size-{guid}`
	end, {})

	local onAdded = useCallback(function(instance: Instance)
		if instance:IsA("GuiObject") then
			setSizeMap(function(prev)
				return Sift.Dictionary.merge(prev, {
					[instance.Name] = instance.AbsoluteSize,
				})
			end)
		end
	end, {})

	local onRemoved = useCallback(function(instance: Instance)
		if instance:IsA("GuiObject") then
			setSizeMap(function(prev)
				return Sift.Dictionary.merge(prev, {
					[instance.Name] = Sift.None,
				})
			end)
		end
	end, {})

	useEffect(function()
		for _, instance in CollectionService:GetTagged(tag) do
			onAdded(instance)
		end

		local added = CollectionService:GetInstanceAddedSignal(tag):Connect(onAdded)
		local removed = CollectionService:GetInstanceRemovedSignal(tag):Connect(onRemoved)

		return function()
			added:Disconnect()
			removed:Disconnect()
		end
	end, {})

	local size = useMemo(function()
		local vec = Vector2.zero
		for _, value in sizeMap do
			vec += value
		end
		return UDim2.fromOffset(vec.X, vec.Y)
	end, { sizeMap })

	return {
		size = size,
		width = UDim2.new(size.X, UDim.new()),
		height = UDim2.new(UDim.new(), size.Y),
		tag = tag,
	}
end

return useCombinedSize
