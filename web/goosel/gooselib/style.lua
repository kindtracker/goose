local StyleModule = {}

local GetElementJavascriptFunction = [[
function GetElement(UniqueId) {
  const Element = Module.GooseElements.get(UniqueId)
  if (Element.tagName == "BODY") {
    return document.body
  }
  return Element
}
]]

function StyleModule.new()
	local self = {}
	self.StyleLoaded = false

	self.StyleLoad = function(Instance)
		Goose:LoadString(string.format(
			[[
      if (!Module.GooseElements) {
        Module.GooseElements = new Map()
      }
      Module.GooseElements.set("%s", document.createElement("div").style)
    ]],
			Instance.UniqueId
		))()
	end

	self.__index = function(Instance, Key)
		if not self.StyleLoaded then
			self.StyleLoad(Instance)
		end

		Key = Key:sub(1, 1):lower() .. Key:sub(2)

		local Value = Goose:LoadString(string.format(
			[[
        %s
        const Element = GetElement("%s")
        return JSON.stringify(Element.style.%s)
    ]],
			GetElementJavascriptFunction,
			Instance.UniqueId,
			Key
		))()

		return JSONService:Decode(Value)
	end

	self.__newindex = function(Instance, Key, NewValue)
		if not self.StyleLoaded then
			self.StyleLoad(Instance)
		end

		Key = Key:sub(1, 1):lower() .. Key:sub(2)

		Goose:LoadString(string.format(
			[[
        %s
        const Element = GetElement("%s")
        Element.style.cssText = Style.cssText
    ]],
			GetElementJavascriptFunction,
			Instance.UniqueId,
			Key,
			NewValue
		))()
	end

	return self
end

function StyleModule:InitPlugin()
	Instance:RegisterClass("HtmlStyle", StyleModule, Instance)
end

return StyleModule
