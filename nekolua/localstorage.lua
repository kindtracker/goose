local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")

local LocalStorage = {}

local CompiledLocalStorageSet = Neko:LoadStringVoid([=[
  window.localStorage.setItem(Arguments[0], Arguments[1])
]=])

local CompiledLocalStorageGet = Neko:LoadString([=[
  return window.localStorage.getItem(Arguments[0])
]=])

local CompiledLocalStorageGetKeys = Neko:LoadString([=[
  const Keys = [];

  for (let i = 0; i < localStorage.length; i++) {
    const Key = localStorage.key(i);
    Keys.push(Key);
  }

  return JSON.stringify(Keys);
]=])

function LocalStorage:Set(Key, Value)
	CompiledLocalStorageSet(Key, Value)
end

function LocalStorage:Get(Key)
	return CompiledLocalStorageGet(Key)
end

function LocalStorage:GetKeys()
	return JSONService:Decode(CompiledLocalStorageGetKeys())
end

function LocalStorage:InitPlugin()
	Neko.Browser.LocalStorage = LocalStorage
end

return LocalStorage
