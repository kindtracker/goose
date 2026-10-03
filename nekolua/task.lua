local Lunar = require("lunar")
local Task = Lunar:GetService("TaskService")

function Task:Delay(Duration, Function)
	Task.delay(Duration, Function)
end

function Task:Wait(Duration)
	Task.duration(Duration)
end

function Task:Every(Duration, Function)
	Task:Spawn(function()
		while true do
			Function()
			Task.wait(Duration)
		end
	end)
end

function Task:Run()
	self.Running = true

	while self.Running do
		self:Step()
		Neko:Yield()
		Neko:ProcessEvents()
	end
end

function Task:Stop()
	self.Running = false
end

function Task:InitPlugin()
	_G.Task = Task
end

return Task
