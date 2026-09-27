local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")
local Module = {}

local GetElementJavascriptFunction = [[
function GetElement(UniqueId) {
  const Element = Module.GooseElements.get(UniqueId)
  if (Element?.tagName == "BODY") {
    return document.body
  }
  return Element
}
]]

local LuaToJavascriptStringTable = {
	InnerHtml = "innerHTML",
	OuterHtml = "outerHTML",
	TextContent = "textContent",
	InnerText = "innerText",

	Id = "id",
	ClassName = "className",
	Title = "title",
	Language = "lang",
	Direction = "dir",
	Slot = "slot",

	AccessKey = "accessKey",
	InputMode = "inputMode",

	Href = "href",
	Target = "target",
	Download = "download",
	Relation = "rel",

	Source = "src",
	Alternative = "alt",

	Value = "value",
	Name = "name",
	Type = "type",
	Placeholder = "placeholder",

	Role = "role",

	Autocomplete = "autocomplete",
	FormAction = "formAction",
	FormMethod = "formMethod",
	FormTarget = "formTarget",
	FormEncoding = "formEnctype",

	CrossOrigin = "crossOrigin",
	ReferrerPolicy = "referrerPolicy",

	Media = "media",
	Kind = "kind",
	Label = "label",

	Poster = "poster",
	Preload = "preload",

	Accept = "accept",
	AcceptCharset = "acceptCharset",
	Charset = "charset",

	Pattern = "pattern",
	Min = "min",
	Max = "max",
	Step = "step",

	Width = "width",
	Height = "height",

	ColSpan = "colSpan",
	RowSpan = "rowSpan",

	Headers = "headers",
	Scope = "scope",

	Cite = "cite",
	DateTime = "dateTime",

	Open = "open",
	Loading = "loading",

	AccessKeyLabel = "accessKeyLabel",
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

	Width = "width",
	Height = "height",

	ColSpan = "colSpan",
	RowSpan = "rowSpan",

	Size = "size",
	MaxLength = "maxLength",
	MinLength = "minLength",

	SelectedIndex = "selectedIndex",

	FilesLength = "length",
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

	NoValidate = "noValidate",
	FormNoValidate = "formNoValidate",

	Controls = "controls",
	Loop = "loop",
	Muted = "muted",
	Autoplay = "autoplay",

	Async = "async",
	Defer = "defer",

	Open = "open",

	Reversed = "reversed",

	Default = "default",

	Indeterminate = "indeterminate",
	Complete = "complete",

	WillValidate = "willValidate",
	ValidityValid = "validity.valid",
}

local LuaToJavascriptElementTable = {
	Parent = "parentElement",
	ParentElement = "parentElement",
	OffsetParent = "offsetParent",

	FirstElementChild = "firstElementChild",
	LastElementChild = "lastElementChild",
	PreviousElementSibling = "previousElementSibling",
	NextElementSibling = "nextElementSibling",

	Form = "form",
	Labels = "labels",

	Select = "select",
	SelectedOptions = "selectedOptions",

	FirstChild = "firstChild",
	LastChild = "lastChild",
	PreviousSibling = "previousSibling",
	NextSibling = "nextSibling",

	OwnerDocument = "ownerDocument",
}

function Module.new()
	local self = {}

	self.__index = function(Instance, Key)
		local JavascriptKey = LuaToJavascriptStringTable[Key]
			or LuaToJavascriptNumberTable[Key]
			or LuaToJavascriptBooleanTable[Key]
		if JavascriptKey then
			local Value = Goose:LoadString(string.format(
				[[
          %s
          const Element = GetElement("%s")
          return JSON.stringify(Element.%s)
      ]],
				GetElementJavascriptFunction,
				Instance.UniqueId,
				JavascriptKey
			))()

			if Value == "undefined" then
				return nil
			end
			return JSONService:Decode(Value)
		end

		if LuaToJavascriptElementTable[Key] then
			local HtmlElement = Lunar.Instance.new("HtmlElement")

			local Value = Goose:LoadString(
				string.format(
					[[
          %s
          const Element = GetElement("%s")
          const Child = Element.%s

          if (!Child) {
            return ""
          }

          Module.GooseElements.set("%s", Child)
          return "Ok"
      ]],
					GetElementJavascriptFunction,
					Instance.UniqueId,
					LuaToJavascriptElementTable[Key],
					HtmlElement.UniqueId
				)
			)()

			if Value == "undefined" then
				return nil
			end
			return HtmlElement
		end
	end

	self.__newindex = function(Instance, Key, NewValue)
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

			Instance.Style = Instance.Style or Lunar.Instance.new("HtmlStyle")
			Goose:LoadString(string.format(
				[[
        %s
        const Element = GetElement("%s")
        Module.GooseElements.set("%s", Element.style)
      ]],
				GetElementJavascriptFunction,
				Instance.UniqueId,
				Instance.Style.UniqueId
			))()
		elseif Key == "Parent" then
			Goose:LoadString(string.format(
				[[
        %s
        const Element = GetElement("%s")
        const Parent = GetElement("%s")
        Parent.appendChild(Element)
      ]],
				GetElementJavascriptFunction,
				Instance.UniqueId,
				NewValue.UniqueId
			))()
		end
	end

	return self
end

function Module:InitPlugin()
	Instance:RegisterClass("HtmlElement", Module, Instance)
end

return Module
