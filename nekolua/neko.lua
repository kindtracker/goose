local Lunar = require("lunar")
local PluginService = Lunar:GetService("PluginService")
local Base = "/nekolib"

Neko:LoadStringVoid([=[
	Module.NekoElements = new Map()
]=])()

PluginService:LoadLuaPlugin("CoreNekoStyle", Base .. "/style.lua")
PluginService:LoadLuaPlugin("CoreNekoHtmlElement", Base .. "/htmlelem.lua")
PluginService:LoadLuaPlugin("CoreNekoPage", Base .. "/page.lua")

Neko:LoadStringVoid([=[
  dispatchEvent(new Event("NekoLuaLoaded"))
]=])()
