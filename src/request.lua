local Root = script:FindFirstAncestor("rbxtheme")

local HttpService = game:GetService("HttpService")

local Promise = require(Root.Packages.Promise)
local Sift = require(Root.Packages.Sift)

local function request(payload)
	return Promise.new(function(resolve, reject)
		print(`{payload.Method} {payload.Url}`)
		local res = HttpService:RequestAsync(payload)
		if res.Success then
			for key, value in res.Headers do
				if typeof(key) == "string" and typeof(value) == "string" then
					if key:lower() == "content-type" and value:lower() == "application/json" then
						res = Sift.Dictionary.join(res, {
							Body = HttpService:JSONDecode(res.Body),
						})
						resolve(res)
						break
					end
				end
			end

			resolve(res)
		else
			reject(`ERR {res.StatusCode} {res.StatusMessage}\nBody: {res.Body}`)
		end
	end)
end

return request
