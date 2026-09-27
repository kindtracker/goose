local Lunar = require("lunar")
local Module = {}

local GetElementJavascriptFunction = [[
function GetElement(UniqueId) {
  const Element = Module.GooseElements.get(UniqueId)
  if (Element.tagName == "BODY") {
    return document.body
  }
  return Element
}
]]

function Module.new()
	local self = {}

	self.__index = function(_, Key) end

	self.__newindex = function(Instance, Key, NewValue)
		if Key == "InnerHtml" then
			Goose:LoadString(string.format(
				[[
        %s
        const Element = GetElement("%s")
        Element.innerHTML = "%s"
      ]],
				GetElementJavascriptFunction,
				Instance.UniqueId,
				NewValue
			))()
		elseif Key == "Parent" then
			Goose:LoadString(string.format(
				[[
        %s
        const Element = Module.GooseElements.get("%s")
        const ParentElement = GetElement("%s")
        ParentElement.appendChild(Element)
      ]],
				GetElementJavascriptFunction,
				Instance.UniqueId,
				NewValue.UniqueId
			))()
		elseif Key == "TagName" then
			NewValue = NewValue:sub(1, 1):lower() .. NewValue:sub(2)
			Goose:LoadString(string.format(
				[[
        if (!Module.GooseElements) {
          Module.GooseElements = new Map()
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
