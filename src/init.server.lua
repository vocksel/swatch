local fetchVisualStudioExtensions = require(script.fetchVisualStudioExtensions)

fetchVisualStudioExtensions():andThen(function(extensions)
	print("extensions", extensions)
end)
