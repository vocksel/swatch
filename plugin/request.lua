local Root = script:FindFirstAncestor("rbxtheme")

local HttpService = game:GetService("HttpService")

local Promise = require(Root.Packages.Promise)
local Sift = require(Root.Packages.Sift)

type HttpMethod = "GET" | "POST" | "PATCH" | "PUT" | "DELETE"

type Polling = {
	times: number,
	seconds: number,
}

type Payload = {
	url: string,
	method: HttpMethod?,
	headers: { [string]: string }?,
	body: string?,
	polling: Polling?,
}

local defaultPolling: Polling = {
	times = 5,
	seconds = 10,
}

local function request(payload)
	local method = if payload.method then payload.method else "GET" :: HttpMethod

	local function makeRequest()
		print(`{method} {payload.url}`)
		return Promise.new(function(resolve, reject)
			local res = HttpService:RequestAsync({
				Url = payload.url,
				Method = method,
				Headers = payload.headers,
				Body = payload.body,
			})
			if res.Success then
				resolve(res)
			else
				reject(`ERR {res.StatusCode} {res.StatusMessage}\nBody: {res.Body}`)
			end
		end)
	end

	if payload.polling then
		local polling = Sift.Dictionary.join(defaultPolling, payload.polling)
		return Promise.retryWithDelay(makeRequest, polling.times, polling.seconds)
	else
		return makeRequest()
	end
end

return request
