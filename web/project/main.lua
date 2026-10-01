local Lunar = require("lunar")
local Task = Lunar:GetService("TaskService")
local Page = Neko.Page

Page.Title = "Neko"

local Oneko = {
	Position = Vector2.new(0, 0),

	TileMap = {
		Idle = {
			Vector2.new(-3, -3),
		},

		Alert = {
			Vector2.new(-7, -3),
		},

		ScratchSelf = {
			Vector2.new(-5, 0),
			Vector2.new(-6, 0),
			Vector2.new(-7, 0),
		},

		ScratchWallN = {
			Vector2.new(0, 0),
			Vector2.new(0, -1),
		},

		ScratchWallS = {
			Vector2.new(-7, -1),
			Vector2.new(-6, -2),
		},

		ScratchWallE = {
			Vector2.new(-2, -2),
			Vector2.new(-2, -3),
		},

		ScratchWallW = {
			Vector2.new(-4, 0),
			Vector2.new(-4, -1),
		},

		Tired = {
			Vector2.new(-3, -2),
		},

		Sleeping = {
			Vector2.new(-2, 0),
			Vector2.new(-2, -1),
		},

		N = {
			Vector2.new(-1, -2),
			Vector2.new(-1, -3),
		},

		NE = {
			Vector2.new(0, -2),
			Vector2.new(0, -3),
		},

		E = {
			Vector2.new(-3, 0),
			Vector2.new(-3, -1),
		},

		SE = {
			Vector2.new(-5, -1),
			Vector2.new(-5, -2),
		},

		S = {
			Vector2.new(-6, -3),
			Vector2.new(-7, -2),
		},

		SW = {
			Vector2.new(-5, -3),
			Vector2.new(-6, -1),
		},

		W = {
			Vector2.new(-4, -2),
			Vector2.new(-4, -3),
		},

		NW = {
			Vector2.new(-1, 0),
			Vector2.new(-1, -1),
		},
	},
}

Oneko.Element = Page.new("Div", Page.Body)
Oneko.Element.Style.Position = "absolute"
Oneko.Element.Style.Width = "32px"
Oneko.Element.Style.Height = "32px"
Oneko.Element.Style.ImageRendering = "pixelated"
Oneko.Element.Style.BackgroundImage = 'url("/oneko.gif")'

while true do
	local Position = Oneko.Position
	Position.X = Position.X + 0.1
	Position.Y = Position.Y + 0.1

	print(Page.MousePosition)

	Oneko.Element.Style.Left = Position.X .. "px"
	Oneko.Element.Style.Top = Position.Y .. "px"
	Neko:Yield()
	Neko:ProcessEvents()
end
