local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")
local StyleModule = {}

local function EscapeString(String)
	return String:gsub("\\", "\\\\"):gsub('"', '\\"'):gsub("\n", "\\n"):gsub("\r", "\\r"):gsub("\t", "\\t")
end

local GetElementJavascriptFunction = [[
function GetElement(UniqueId) {
  const Element = Module.GooseElements.get(UniqueId)
  if (Element?.tagName == "BODY") {
    return document.body
  }
  return Element
}
]]

local VerifyJavascriptFunction = [[
if (!Style) {
  return ""
}
]]

function StyleModule.new()
	local self = {}

	self.__index = function(Instance, Key)
		Key = Key:sub(1, 1):lower() .. Key:sub(2)

		local Value = Goose:LoadString(string.format(
			[[
        %s
        const Style = GetElement("%s")
        %s
        return JSON.stringify(Style.%s)
    ]],
			GetElementJavascriptFunction,
			Instance.UniqueId,
			VerifyJavascriptFunction,
			Key
		))()

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

		Goose:LoadString(string.format(
			[[
        %s
        const Style = GetElement("%s")
        %s
        Style.%s = "%s"
    ]],
			GetElementJavascriptFunction,
			Instance.UniqueId,
			VerifyJavascriptFunction,
			Key,
			EscapeString(NewValue)
		))()
	end

	return self
end

function StyleModule:InitPlugin()
	Instance:RegisterClass("HtmlStyle", StyleModule, Instance)
end

return StyleModule
