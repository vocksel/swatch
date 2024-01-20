local nextOrder = 0

local function getLayoutOrder()
	nextOrder += 1
	return nextOrder
end

return getLayoutOrder
