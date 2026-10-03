local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")

local Browser = {}

local CompiledRunWindowFunctionVoid = Neko:LoadStringVoid([=[
  window[Arguments[0]](Arguments[1])
]=])

local CompiledRunWindowFunction = Neko:LoadString([=[
  const Result = window[Arguments[0]](Arguments[1])
  return Result.toString()
]=])

local CompiledGetWindowProperty = Neko:LoadString([=[
  const Value = window[Arguments[0]]
  return Value.toString()
]=])

local CompiledGetNavigatorProperty = Neko:LoadString([=[
  const Value = navigator[Arguments[0]]
  return Value.toString()
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

local CompiledSetCookies = Neko:LoadStringVoid([=[
  window.cookie = Arguments[0]
]=])

local CompiledGetCookies = Neko:LoadString([=[
  return window.cookie
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

local BrowserProxy = setmetatable({}, {
	__index = function(_, Key)
		if Key == "Online" then
			return JSONService:Decode(CompiledGetWindowProperty("onLine"))
		elseif Key == "Language" then
			return CompiledGetWindowProperty("language")
		elseif Key == "Languages" then
			return JSONService:Decode(CompiledGetWindowProperty("languages"))
		elseif Key == "UserAgent" then
			return CompiledGetNavigatorProperty("userAgent")
		elseif Key == "Platform" then
			return CompiledGetNavigatorProperty("platform")
		elseif Key == "Cookies" then
			return CompiledGetCookies()
		end

		return Browser[Key]
	end,

	__newindex = function(_, Key, Value)
		if Key == "Cookies" then
			return CompiledSetCookies(Value)
		end

		Browser[Key] = Value
	end,
})

function Browser:InitPlugin()
	Neko.Browser = BrowserProxy
end

return Browser
