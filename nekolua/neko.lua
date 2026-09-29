local Lunar = require("lunar")
local PluginService = Lunar:GetService("PluginService")
local Base = "/nekolib"

PluginService:LoadLuaPlugin("CoreNekoStyle", Base .. "/style.lua")
PluginService:LoadLuaPlugin("CoreNekoHtmlElement", Base .. "/htmlelem.lua")
PluginService:LoadLuaPlugin("CoreNekoPage", Base .. "/page.lua")

Neko:LoadString([[
  dispatchEvent(new Event("NekoLuaLoaded"))
]])()
