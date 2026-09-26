local PagePlugin = {}

function PagePlugin:SetTitle(Title)
	Goose:LoadString([[
    document.title = "]] .. Title .. '"')()
end

function PagePlugin:InitPlugin()
	Goose.Page = PagePlugin
end

return PagePlugin
