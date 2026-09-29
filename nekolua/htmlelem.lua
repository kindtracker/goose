local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")
local Module = {}

local GetElementJavascriptFunction = [[
function GetElement(UniqueId) {
  const Element = Module.NekoElements.get(UniqueId)
  if (Element?.tagName == "BODY") {
    return document.body
  } else if (Element?.tagName == "HEAD") {
    return document.head
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

local LuaToJavascriptTagNameTable = {
	Html = "html",
	Head = "head",
	Body = "body",

	Title = "title",
	Base = "base",
	Link = "link",
	Meta = "meta",
	Style = "style",
	Script = "script",
	Noscript = "noscript",

	Div = "div",
	Span = "span",
	P = "p",
	Br = "br",
	Hr = "hr",

	H1 = "h1",
	H2 = "h2",
	H3 = "h3",
	H4 = "h4",
	H5 = "h5",
	H6 = "h6",

	A = "a",
	Img = "img",
	Video = "video",
	Audio = "audio",
	Source = "source",
	Track = "track",
	Picture = "picture",
	Iframe = "iframe",

	Form = "form",
	Input = "input",
	Button = "button",
	Textarea = "textarea",
	Select = "select",
	Option = "option",
	Label = "label",

	Ul = "ul",
	Ol = "ol",
	Li = "li",

	Table = "table",
	Thead = "thead",
	Tbody = "tbody",
	Tfoot = "tfoot",
	Tr = "tr",
	Th = "th",
	Td = "td",

	Section = "section",
	Article = "article",
	Header = "header",
	Footer = "footer",
	Nav = "nav",
	Main = "main",
	Aside = "aside",

	Canvas = "canvas",
	Svg = "svg",

	Details = "details",
	Summary = "summary",
	Dialog = "dialog",
	Figure = "figure",
	Figcaption = "figcaption",
	Time = "time",
	Pre = "pre",
	Code = "code",
	Blockquote = "blockquote",
}

local CompiledGetStringOrNumberOrBooleanProperty = Neko:LoadString(GetElementJavascriptFunction .. [=[
	const Element = GetElement(Arguments[0])
	return JSON.stringify(Element[Arguments[1]])
]=])

local CompiledGetElementProperty = Neko:LoadString(GetElementJavascriptFunction .. [=[
	const Element = GetElement(Arguments[0])
	const Child = Element[Arguments[1]]

	if (!Child) {
		return "404"
	}

	Module.NekoElements.set(Arguments[2], Child)

	return "Ok"
]=])

local CompiledSetStringProperty = Neko:LoadStringVoid(GetElementJavascriptFunction .. [=[
	const Element = GetElement(Arguments[0])
	Element[Arguments[1]] = Arguments[2]
]=])

local CompiledSetNumberOrBooleanProperty = Neko:LoadStringVoid(GetElementJavascriptFunction .. [=[
	const Element = GetElement(Arguments[0])
	Element[Arguments[1]] = Arguments[2]
]=])

local CompiledCreateElement = Neko:LoadStringVoid([=[
	Module.NekoElements.set(
		Arguments[0],
		document.createElement(Arguments[1])
	)
]=])

local CompiledSetStyleElement = Neko:LoadStringVoid(GetElementJavascriptFunction .. [=[
	const Element = GetElement(Arguments[0])
	Module.NekoElements.set(Arguments[1], Element.style)
]=])

local CompiledAppendChild = Neko:LoadStringVoid(GetElementJavascriptFunction .. [=[
	const Element = GetElement(Arguments[0])
	const Parent = GetElement(Arguments[1])

	Parent.appendChild(Element)
]=])

function Module.new()
	local self = {}

	self.__index = function(Instance, Key)
		local JavascriptKey = LuaToJavascriptStringTable[Key]
			or LuaToJavascriptNumberTable[Key]
			or LuaToJavascriptBooleanTable[Key]
		if JavascriptKey then
			local Value = CompiledGetStringOrNumberOrBooleanProperty(Instance.UniqueId, JavascriptKey)

			if Value == "undefined" then
				return nil
			end
			return JSONService:Decode(Value)
		end

		if LuaToJavascriptElementTable[Key] then
			local HtmlElement = Lunar.Instance.new("HtmlElement")

			local Value =
				CompiledGetElementProperty(Instance.UniqueId, LuaToJavascriptElementTable[Key], HtmlElement.UniqueId)
			if Value == "404" then
				return nil
			end
			return HtmlElement
		end
	end

	self.__newindex = function(Instance, Key, NewValue)
		if LuaToJavascriptStringTable[Key] then
			CompiledSetStringProperty(Instance.UniqueId, LuaToJavascriptStringTable[Key], NewValue)
		elseif LuaToJavascriptNumberTable[Key] or LuaToJavascriptBooleanTable[Key] then
			CompiledSetNumberOrBooleanProperty(
				Instance.UniqueId,
				LuaToJavascriptNumberTable[Key] or LuaToJavascriptBooleanTable[Key],
				tostring(NewValue)
			)
		end

		if Key == "TagName" then
			CompiledCreateElement(Instance.UniqueId, LuaToJavascriptTagNameTable[NewValue])

			Instance.Style = Instance.Style or Lunar.Instance.new("HtmlStyle")
			CompiledSetStyleElement(Instance.UniqueId, Instance.Style.UniqueId)
		elseif Key == "Parent" then
			CompiledAppendChild(Instance.UniqueId, NewValue.UniqueId)
		end
	end

	return self
end

function Module:InitPlugin()
	Instance:RegisterClass("HtmlElement", Module, Instance)
end

return Module
