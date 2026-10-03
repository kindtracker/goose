local Lunar = require("lunar")
local Task = Lunar:GetService("TaskService")
local Page = Neko.Page

Page.Title = "Neko"

local Oneko = {
	Position = Vector2.new(0, 0),
	Speed = 10,
	Dragging = false,
	Offset = Vector2.new(0, 0),
	FrameCount = 0,
	IdleTime = 0,
	IdleFrameCount = 0,
	IdleAnimation = nil,

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

local function SetSprite(SpriteName, Divide)
	Divide = Divide or 1
	local SpriteFrames = Oneko.TileMap[SpriteName]
	local SpritePosition = SpriteFrames[(math.floor(Oneko.FrameCount / Divide) % #SpriteFrames) + 1]
	Oneko.Element.Style.BackgroundPosition = SpritePosition.X * 32 .. "px " .. SpritePosition.Y * 32 .. "px"
end

Oneko.Element = Page.new("Div", Page.Body)
Oneko.Element.Style.Position = "absolute"
Oneko.Element.Style.Width = "32px"
Oneko.Element.Style.Height = "32px"
Oneko.Element.Style.ImageRendering = "pixelated"
Oneko.Element.Style.BackgroundImage = 'url("/oneko.gif")'

Oneko.Element.MouseDown:Connect(function(Event)
	Oneko.Dragging = true
	Oneko.Offset = Vector2.new(Event.ClientX - Oneko.Position.X, Event.ClientY - Oneko.Position.Y)

	local Clone = Oneko.Element:Clone()
	Clone.Parent = Page.Body
end)

Page.Document.MouseUp:Connect(function(Event)
	Oneko.Dragging = false
end)

function Idle(Oneko)
	Oneko.IdleTime = Oneko.IdleTime + 1

	if not Oneko.IdleAnimation and math.random(1, 25) == 1 then
		local AvailableIdleAnimations = {
			"Sleeping",
			"ScratchSelf",
		}

		Oneko.IdleAnimation = AvailableIdleAnimations[math.random(1, #AvailableIdleAnimations)]

		if Oneko.Position.X < 16 * 3 then
			Oneko.IdleAnimation = "ScratchWallW"
			Oneko.Position.X = 0
		elseif Oneko.Position.Y < 16 * 3 then
			Oneko.IdleAnimation = "ScratchWallN"
			Oneko.Position.Y = 0
		elseif Oneko.Position.X > Page.Size.X - 16 * 3 then
			Oneko.IdleAnimation = "ScratchWallE"
			Oneko.Position.X = Page.Size.X - 16
		elseif Oneko.Position.Y > Page.Size.Y - 16 * 3 then
			Oneko.IdleAnimation = "ScratchWallS"
			Oneko.Position.Y = Page.Size.Y - 16
		end

		Oneko.IdleTime = 0
	end
	if not Oneko.IdleAnimation then
		SetSprite("Idle")
		return
	end

	if Oneko.IdleAnimation == "Sleeping" then
		if Oneko.IdleTime < 8 * 2 then
			SetSprite("Tired")
		else
			SetSprite("Sleeping", 3)
		end
		if Oneko.IdleTime > 8 * 24 then
			Oneko.IdleAnimation = nil
			Oneko.IdleTime = 0
		end
	elseif Oneko.IdleAnimation == "ScratchSelf" then
		if Oneko.IdleTime > 8 * 4 then
			Oneko.IdleAnimation = nil
			Oneko.IdleTime = 0
			return
		end
		SetSprite("ScratchSelf", 1.5)
	elseif Oneko.IdleAnimation:find("Scratch") then
		if Oneko.IdleTime > 8 * 6 then
			Oneko.IdleAnimation = nil
			Oneko.IdleTime = 0
			return
		end
		SetSprite(Oneko.IdleAnimation, 2)
	end
end

Task:Spawn(function()
	while true do
		local Position = Oneko.Position
		local Target = Page.MousePosition

		if Oneko.Dragging then
			Oneko.Position = Target - Oneko.Offset
			Oneko.IdleAnimation = nil
			Oneko.IdleTime = 0
			Target = Oneko.Position

			SetSprite("Idle")
			Oneko.Element.Style.Left = Target.X .. "px"
			Oneko.Element.Style.Top = Target.Y .. "px"
		elseif Target ~= nil then
			Target = Target - Vector2.new(16, 16)
			local Difference = Position - Target
			local Distance = math.sqrt(Difference.X ^ 2 + Difference.Y ^ 2)

			if Distance > 42 then
				Oneko.IdleTime = 0
				Oneko.IdleAnimation = nil

				Position = Position - (Difference / Distance * Oneko.Speed)
				Position.X = math.max(math.min(Position.X, Page.Size.X - 32), 0)
				Position.Y = math.max(math.min(Position.Y, Page.Size.Y - 32), 0)
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
			else
				Idle(Oneko)
			end
		end

		Oneko.FrameCount = Oneko.FrameCount + 1

		if not Oneko.Dragging then
			Task.wait(0.1)
		else
			Task.wait(0)
		end
	end
end)

while true do
	Task:Step()
	Neko:Yield()
	Neko:ProcessEvents()
end
