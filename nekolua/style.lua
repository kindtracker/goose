local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")
local StyleModule = {}

local GetElementJavascriptFunction = [[
function GetElement(UniqueId) {
  const Element = Module.NekoElements.get(UniqueId)
  if (Element?.tagName == "BODY") {
    return document.body
  }
  return Element
}
]]

local CompiledGetStringProperty = Neko:LoadString(GetElementJavascriptFunction .. [=[
  const Style = GetElement(Arguments[0])
  if (!Style) {
    return ""
  }
  return JSON.stringify(Style[Arguments[1]])
]=])

local CompiledSetStringProperty = Neko:LoadStringVoid(GetElementJavascriptFunction .. [=[
  const Style = GetElement(Arguments[0])
  if (!Style) {
    return
  }
  Style[Arguments[1]] = Arguments[2]
]=])

function StyleModule.new()
	local self = {}

	self.__index = function(Instance, Key)
		Key = Key:sub(1, 1):lower() .. Key:sub(2)

		local Value = CompiledGetStringProperty(Instance.UniqueId, Key)

		if Value == "" then
			return
		end
		return JSONService:Decode(Value)
	end

	self.__newindex = function(Instance, Key, NewValue)
		if type(NewValue) ~= "string" then
			return
		end
		Key = Key:sub(1, 1):lower() .. Key:sub(2)

		CompiledSetStringProperty(Instance.UniqueId, Key, NewValue)
	end

	return self
end

function StyleModule:InitPlugin()
	Instance:RegisterClass("HtmlStyle", StyleModule, Instance)
end

return StyleModule
