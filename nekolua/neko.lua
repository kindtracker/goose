local Lunar = require("lunar")
local PluginService = Lunar:GetService("PluginService")
local EventModule = require("nekolib/event")
local Base = "/nekolib"

Neko:LoadStringVoid([=[
	Module.NekoElements = new Map()
	Module.NekoEvents = []
]=])()

PluginService:LoadLuaPlugin("CoreNekoStyle", Base .. "/style.lua")
PluginService:LoadLuaPlugin("CoreNekoHtmlElement", Base .. "/htmlelem.lua")
PluginService:LoadLuaPlugin("CoreNekoPage", Base .. "/page.lua")
Neko.ProcessEvents = EventModule.ProcessEvents

Neko:LoadStringVoid([=[
  dispatchEvent(new Event("NekoLuaLoaded"))
]=])()
