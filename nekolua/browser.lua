local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")

local Browser = {}

local CompiledRunWindowFunctionVoid = Neko:LoadStringVoid([=[
  window[Arguments[0]](Arguments[1])
]=])

local CompiledRunWindowFunction = Neko:LoadStringVoid([=[
  const Result = window[Arguments[0]](Arguments[1])
  return Result.toString()
]=])

function Browser:Alert(Message)
	CompiledRunWindowFunctionVoid("alert", tostring(Message))
end

function Browser:Confirm(Message)
	local Result = CompiledRunWindowFunction("confirm", tostring(Message))
	return JSONService:Decode(Result)
end

function Browser:Prompt(Message)
	local Result = CompiledRunWindowFunction("prompt", tostring(Message))
	return JSONService:Decode(Result)
end

function Browser:Open(Url)
	CompiledRunWindowFunctionVoid("open", tostring(Url))
end

function Browser:InitPlugin()
	Neko.Browser = Browser
end

return Browser
