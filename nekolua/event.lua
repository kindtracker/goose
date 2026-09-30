local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")
local LString = Luanr:GetService("LStringLibrary")
local EventModule = {}

local AllElements = {}

local GetElementJavascriptFunction = [[
function GetElement(UniqueId) {
  const Element = Module.NekoElements.get(UniqueId)
  if (Element?.tagName == "BODY") {
    return document.body
  } else if (Element?.tagName == "HEAD") {
    return document.head
  }
  return Element
}
]]

local CompiledAddEventListener = Neko:LoadStringVoid(GetElementJavascriptFunction .. [=[
  const Element = GetElement(Arguments[0])
  Element.addEventListener(Arguments[1], () => {
    Module.NekoEvents.push(Arguments[0] .. "$" .. Arguments[2])
  })
]=])

local CompiledGetEvents = Neko:LoadString([=[
  return JSON.stringify(Module.NekoEvents)
]=])

function EventModule.new(Element, EventName, JavascriptEventName)
	AllElements[Element.UniqueId] = Element
	CompiledAddEventListener(Element.UniqueId, JavascriptEventName, EventName)
	return Signal.new()
end

function EventModule:ProcessEvents()
	local Events = JSONService:Decode(CompiledGetEvents())

	for Index, Event in ipairs(Events) do
		local ElementId, EventName = table.unpack(LString.split(Event, "$"))
		local Element = AllElements[ElementId]
		Element[EventName]:Fire() -- TODO: add arguments
	end
end

return EventModule
