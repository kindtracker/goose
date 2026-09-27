local Lunar = require("lunar")
local PluginService = Lunar:GetService("PluginService")
local Base = "/gooselib"

PluginService:LoadLuaPlugin("CoreGooseStyle", Base .. "/style.lua")
PluginService:LoadLuaPlugin("CoreGooseHtmlElement", Base .. "/htmlelem.lua")
PluginService:LoadLuaPlugin("CoreGoosePage", Base .. "/page.lua")

Goose:LoadString([[
  dispatchEvent(new Event("GooseLuaLoaded"))
]])()
