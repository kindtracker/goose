local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")

local SessionStorage = {}

local CompiledSessionStorageSet = Neko:LoadStringVoid([=[
  window.sessionStorage.setItem(Arguments[0], Arguments[1])
]=])

local CompiledSessionStorageGet = Neko:LoadString([=[
  return window.sessionStorage.getItem(Arguments[0])
]=])

local CompiledSessionStorageGetKeys = Neko:LoadString([=[
  const Keys = [];

  for (let i = 0; i < sessionStorage.length; i++) {
    const Key = sessionStorage.key(i);
    Keys.push(Key);
  }

  return JSON.stringify(Keys);
]=])

function SessionStorage:Set(Key, Value)
	CompiledSessionStorageSet(Key, Value)
end

function SessionStorage:Get(Key)
	return CompiledSessionStorageGet(Key)
end

function SessionStorage:GetKeys()
	return JSONService:Decode(CompiledSessionStorageGetKeys())
end

function SessionStorage:InitPlugin()
	Neko.Browser.SessionStorage = SessionStorage
end

return SessionStorage
