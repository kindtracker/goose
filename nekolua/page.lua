local PagePlugin = {}

function PagePlugin.new(TagName, Parent)
	local Element = Instance.new("HtmlElement")
	Element.TagName = TagName

	return Element
end

function PagePlugin:SetTitle(Title)
	Neko:LoadString([[
    document.title = "]] .. Title .. '"')()
end

function PagePlugin:InitPlugin()
	local BodyElement = Instance.new("HtmlElement")
	BodyElement.TagName = "Body"
	PagePlugin.Body = BodyElement

	Neko.Page = PagePlugin
end

return PagePlugin
