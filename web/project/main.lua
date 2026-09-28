local Lunar = require("lunar")
local Task = Lunar:GetService("TaskService")
local Page = Goose.Page

Page:SetTitle("Goose")

Page.Body.Style.BackgroundImage = 'url("https://melonking.net/images/flood-water-solid.png")'

Task:Spawn(function()
	while true do
		print("a")
		Task.wait(0.07)
	end
end)

while true do
	Task:Step()
	Goose:Yield()
end
