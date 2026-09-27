local Lunar = require("lunar")
local Page = Goose.Page

Page:SetTitle("Goose - Lua Loaded")

local Div = Page.new("div")
print("test", Div)
Div.InnerHtml = "hiiiiiii"
