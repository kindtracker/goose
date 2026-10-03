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

local CompiledReload = Neko:LoadStringVoid([=[
  window.location.reload()
]=])

local CompiledBack = Neko:LoadStringVoid([=[
  history.back()
]=])

local CompiledForward = Neko:LoadStringVoid([=[
  history.forward()
]=])

local CompiledBlur = Neko:LoadStringVoid([=[
  window.blur()
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

function Browser:Reload()
	CompiledReload()
end

function Browser:Back()
	CompiledBack()
end

function Browser:Forward()
	CompiledForward()
end

function Browser:Focus()
	CompiledRunWindowFunctionVoid("focus")
end

function Browser:Blur()
	CompiledBlur()
end

function Browser:InitPlugin()
	Neko.Browser = Browser
end

return Browser
