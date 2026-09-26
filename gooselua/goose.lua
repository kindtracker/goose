local Lunar = require("lunar")
local PluginService = Lunar:GetService("PluginService")
local Base = "/gooselib"

PluginService:LoadLuaPlugin("CoreGoosePage", Base .. "/page.lua")

Goose:LoadString([[
  dispatchEvent(new Event("GooseLuaLoaded"))
]])()
