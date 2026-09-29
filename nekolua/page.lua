local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")

local Page = {}

local CompiledGetPageTitle = Neko:LoadString([=[
	return document.title
]=])

local CompiledSetPageTitle = Neko:LoadStringVoid([=[
	document.title = Arguments[0]
]=])

local CompiledSelectorAllCount = Neko:LoadString([=[
	return document.querySelectorAll(Arguments[0]).length
]=])

local CompiledSelectorAll = Neko:LoadStringVoid([=[
	const AllElements = document.querySelectorAll(Arguments[0])
	let Index = 1

	AllElements.forEach((Element) => {
		Module.NekoElements.set(Arguments[Index], Element)
		Index++
	})
]=])

local PageProxy = setmetatable({}, {
	__index = function(_, Key)
		if Key == "Title" then
			return CompiledGetPageTitle()
		end

		return Page[Key]
	end,

	__newindex = function(_, Key, Value)
		if Key == "Title" then
			return CompiledSetPageTitle(Value)
		end

		Page[Key] = Value
	end,
})

function Page.new(TagName, Parent)
	local Element = Instance.new("HtmlElement")

	Element.TagName = TagName
	Element.Parent = Parent

	return Element
end

function Page:SetTitle(Title)
	CompiledSetPageTitle(Title)
end

function Page:QuerySelectorAll(Selector)
	local Count = CompiledSelectorAllCount(Selector)

	if Count == 0 then
		return {}
	end

	local Elements = {}

	for _ = 1, Count do
		table.insert(Elements, Instance.new("HtmlElement"))
	end

	local ElementUniqueIds = {}

	for _, Element in ipairs(Elements) do
		table.insert(ElementUniqueIds, Element.UniqueId)
	end

	CompiledSelectorAll(Selector, table.unpack(ElementUniqueIds))

	return Elements
end

function Page:QuerySelector(Selector)
	local Elements = Page:QuerySelectorAll(Selector)
	if #Elements ~= 0 then
		return Elements[1]
	end

	return nil
end

function Page:GetElementById(Id)
	return Page:QuerySelector("#" .. Id)
end

function Page:InitPlugin()
	local BodyElement = Instance.new("HtmlElement")
	BodyElement.TagName = "Body"

	Page.Body = BodyElement

	local HeadElement = Instance.new("HtmlElement")
	HeadElement.TagName = "Head"

	Page.Head = HeadElement

	Page.Location = JSONService:Decode(Neko:LoadString([=[
			return JSON.stringify({
				Hash: window.location.hash,
				HostName: window.location.hostname,
				Href: window.location.href,
				Origin: window.location.origin,
				Path: window.location.pathname,
				Port: window.location.port,
				Protocol: window.location.protocol
			})
		]=])())

	Neko.Page = PageProxy
end

return Page
