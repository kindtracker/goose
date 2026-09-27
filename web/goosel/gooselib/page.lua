local PagePlugin = {}

function PagePlugin.new(TagName, Parent)
	local Element = Instance.new("HtmlElement")
	Element.TagName = TagName

	return Element
end

function PagePlugin:SetTitle(Title)
	Goose:LoadString([[
    document.title = "]] .. Title .. '"')()
end

function PagePlugin:InitPlugin()
	local BodyElement = Instance.new("HtmlElement")
	BodyElement.TagName = "Body"
	PagePlugin.Body = BodyElement

	Goose.Page = PagePlugin
end

return PagePlugin
