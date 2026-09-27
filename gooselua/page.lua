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
	Goose.Page = PagePlugin
end

return PagePlugin
