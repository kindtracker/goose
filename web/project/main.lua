local Lunar = require("lunar")
local Task = Lunar:GetService("TaskService")
local Page = Neko.Page

Page:SetTitle("Neko")

local FloodLayers = {
	{
		SpeedX = 0.17,
		SpeedY = 0.01,
		BlendMode = "screen",
	},

	{
		SpeedX = 0.35,
		SpeedY = 0.17,
		BlendMode = "darken",
	},

	{
		SpeedX = 0.25,
		SpeedY = 0.016,
		BlendMode = "darken",
	},

	{
		SpeedX = 0.20,
		SpeedY = 0.07,
		BlendMode = "overlay",
	},

	{
		SpeedX = 0.30,
		SpeedY = 0.04,
		BlendMode = "soft-light",
	},
}

local Images = { "linear-gradient(rgba(0, 20, 40, 0.225), rgba(0, 20, 40, 0.225))" }
local Repeats = { "repeat" }
local BlendModes = { "normal" }

for _, Layer in ipairs(FloodLayers) do
	table.insert(Images, 'url("https://melonking.net/images/flood-water-solid.png")')
	table.insert(Repeats, "repeat")
	table.insert(BlendModes, Layer.BlendMode)
	Layer.X = math.random(0, 600)
	Layer.Y = math.random(0, 600)
	print(Layer.X)
end

Page.Body.Style.BackgroundImage = table.concat(Images, ", ")
Page.Body.Style.BackgroundRepeat = table.concat(Repeats, ", ")
Page.Body.Style.BackgroundBlendMode = table.concat(BlendModes, ", ")

Task:Spawn(function()
	while true do
		local Positions = {}
		for _, Layer in ipairs(FloodLayers) do
			table.insert(Positions, string.format("%.2fpx %.2fpx", Layer.X, Layer.Y))
			Layer.X = Layer.X + Layer.SpeedX
			Layer.Y = Layer.Y + Layer.SpeedY
		end
		Page.Body.Style.BackgroundPosition = table.concat(Positions, ", ")

		Task.wait(0)
	end
end)

while true do
	Task:Step()
	Neko:Yield()
end
