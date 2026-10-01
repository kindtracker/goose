local Lunar = require("lunar")
local Task = Lunar:GetService("TaskService")
local Page = Neko.Page

Page.Title = "Neko"

local Oneko = {
	Position = Vector2.new(0, 0),
	Speed = 10,
	FrameCount = 0,

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

local function SetSprite(SpriteName)
	local SpriteFrames = Oneko.TileMap[SpriteName]
	local SpritePosition = SpriteFrames[(Oneko.FrameCount % #SpriteFrames) + 1]
	Oneko.Element.Style.BackgroundPosition = SpritePosition.X * 32 .. "px " .. SpritePosition.Y * 32 .. "px"
end

Oneko.Element = Page.new("Div", Page.Body)
Oneko.Element.Style.Position = "absolute"
Oneko.Element.Style.Width = "32px"
Oneko.Element.Style.Height = "32px"
Oneko.Element.Style.ImageRendering = "pixelated"
Oneko.Element.Style.BackgroundImage = 'url("/oneko.gif")'

Task:Spawn(function()
	while true do
		local Position = Oneko.Position
		local Target = Page.MousePosition

		if Target ~= nil then
			local Difference = Position - Target
			local Distance = math.sqrt(Difference.X ^ 2 + Difference.Y ^ 2)

			if Distance > Oneko.Speed then
				Position = Position - (Difference / Distance * Oneko.Speed)
				Oneko.Position = Position

				local Direction = ""

				if Difference.Y / Distance > 0.5 then
					Direction = Direction .. "N"
				elseif Difference.Y / Distance < -0.5 then
					Direction = Direction .. "S"
				end

				if Difference.X / Distance < -0.5 then
					Direction = Direction .. "E"
				elseif Difference.X / Distance > 0.5 then
					Direction = Direction .. "W"
				end

				SetSprite(Direction)

				Oneko.Element.Style.Left = Position.X .. "px"
				Oneko.Element.Style.Top = Position.Y .. "px"
			end
		end

		Oneko.FrameCount = Oneko.FrameCount + 1

		Task.wait(0.1)
	end
end)

while true do
	Task:Step()
	Neko:Yield()
	Neko:ProcessEvents()
end
