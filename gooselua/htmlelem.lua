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

local LuaToJavascriptStringTable = {
	InnerHTML = "innerHTML",
	OuterHTML = "outerHTML",
	TextContent = "textContent",
	InnerText = "innerText",

	Id = "id",
	ClassName = "className",
	Title = "title",
	Lang = "lang",
	Dir = "dir",
	Slot = "slot",

	AccessKey = "accessKey",
	InputMode = "inputMode",

	Href = "href",
	Target = "target",
	Download = "download",
	Rel = "rel",

	Src = "src",
	Alt = "alt",

	Value = "value",
	Name = "name",
	Type = "type",
	Placeholder = "placeholder",

	Role = "role",
}

local LuaToJavascriptNumberTable = {
	ClientWidth = "clientWidth",
	ClientHeight = "clientHeight",
	ClientLeft = "clientLeft",
	ClientTop = "clientTop",

	OffsetWidth = "offsetWidth",
	OffsetHeight = "offsetHeight",
	OffsetLeft = "offsetLeft",
	OffsetTop = "offsetTop",

	ScrollWidth = "scrollWidth",
	ScrollHeight = "scrollHeight",
	ScrollLeft = "scrollLeft",
	ScrollTop = "scrollTop",

	TabIndex = "tabIndex",
}

local LuaToJavascriptBooleanTable = {
	Hidden = "hidden",
	Draggable = "draggable",
	ContentEditable = "contentEditable",
	Spellcheck = "spellcheck",
	Translate = "translate",

	Disabled = "disabled",
	Required = "required",
	ReadOnly = "readOnly",
	Checked = "checked",
	Selected = "selected",
	Multiple = "multiple",
	Autofocus = "autofocus",
}

local LuaToJavascriptElementTable = {
	Parent = "parentElement",
	ParentElement = "parentElement",
	FirstElementChild = "firstElementChild",
	LastElementChild = "lastElementChild",
	PreviousElementSibling = "previousElementSibling",
	NextElementSibling = "nextElementSibling",

	OffsetParent = "offsetParent",
}

local LuaToJavascriptStyleTable = {
	Style = "style",
}

function Module.new()
	local self = {}

	self.__index = function(_, Key) end

	self.__newindex = function(Instance, Key, NewValue)
		local LuaToJavascriptTable = {
			InnerHTML = "innerHTML",
			OuterHTML = "outerHTML",
			Language = "lang",
		}
		if LuaToJavascriptStringTable[Key] then
			Goose:LoadString(string.format(
				[[
        %s
        const Element = GetElement("%s")
        Element.%s = "%s"
      ]],
				GetElementJavascriptFunction,
				Instance.UniqueId,
				LuaToJavascriptStringTable[Key],
				NewValue
			))()
		elseif LuaToJavascriptNumberTable[Key] or LuaToJavascriptBooleanTable[Key] then
			Goose:LoadString(
				string.format(
					[[
        %s
        const Element = GetElement("%s")
        Element.%s = %s
      ]],
					GetElementJavascriptFunction,
					Instance.UniqueId,
					LuaToJavascriptNumberTable[Key] or LuaToJavascriptBooleanTable[Key],
					tostring(NewValue)
				)
			)()
		end

		if Key == "TagName" then
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
