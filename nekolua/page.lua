local Page = {}

local CompiledGetPageTitle = Neko:LoadString([=[
  return document.title
]=])

local CompiledSetPageTitle = Neko:LoadString([=[
  document.title = Arguments[0]
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

	return Element
end

function Page:SetTitle(Title)
	CompiledSetPageTitle(Title)
end

function Page:InitPlugin()
	local BodyElement = Instance.new("HtmlElement")
	BodyElement.TagName = "Body"
	Page.Body = BodyElement

	local HeadElement = Instance.new("HtmlElement")
	HeadElement.TagName = "Head"
	Page.Head = HeadElement

	Neko.Page = PageProxy
end

return Page
