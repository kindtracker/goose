local Lunar = require("lunar")
local Module = {}

function Module.new()
	local self = {}

	self.__index = function(_, Key) end

	self.__newindex = function(Instance, Key, NewValue)
		if Key == "InnerHtml" then
		elseif Key == "TagName" then
			NewValue = NewValue:sub(1, 1):lower() .. NewValue:sub(2)
			Goose:LoadString(string.format(
				[[
        if (!Module.GooseElements) {
          Module.GooseElements = new Map();
        }
        Module.GooseElements.set("%s", document.createElement("%s"))
      ]],
				Instance.UniqueId,
				NewValue
			))()
		end
	end

	return self
end

function Module:InitPlugin()
	Instance:RegisterClass("HtmlElement", Module, Instance)
end

return Module
