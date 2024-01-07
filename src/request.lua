local Root = script:FindFirstAncestor("rbxtheme")

local HttpService = game:GetService("HttpService")

local Promise = require(Root.Packages.Promise)

local function request(payload)
	return Promise.new(function(resolve, reject)
		local res = HttpService:RequestAsync(payload)
		if res.Success then
			resolve(res)
		else
			reject(`ERR {res.StatusCode} {res.StatusMessage}\nBody: {res.Body}`)
		end
	end)
end

return request
