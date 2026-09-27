local Lunar = require("lunar")
local Page = Goose.Page

Page:SetTitle("Goose - Lua Loaded")

local Div = Page.new("div")
Div.InnerHtml = "hiiiiiii"
Div.Parent = Page.Body
