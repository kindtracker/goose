local Lunar = require("lunar")
local JSONService = Lunar:GetService("JSONService")
local LString = Lunar:GetService("LStringLibrary")

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
  Element.addEventListener(Arguments[1], (Event) => {
    const EventData = {
      type: Event.type,
      target: Event.target,
      currentTarget: Event.currentTarget,
      timeStamp: Event.timeStamp,
      defaultPrevented: Event.defaultPrevented,
      bubbles: Event.bubbles,
      cancelable: Event.cancelable,
      isTrusted: Event.isTrusted,

      clientX: Event.clientX,
      clientY: Event.clientY,
      pageX: Event.pageX,
      pageY: Event.pageY,
      screenX: Event.screenX,
      screenY: Event.screenY,

      offsetX: Event.offsetX,
      offsetY: Event.offsetY,

      button: Event.button,
      buttons: Event.buttons,

      movementX: Event.movementX,
      movementY: Event.movementY,

      pressure: Event.pressure,
      tiltX: Event.tiltX,
      tiltY: Event.tiltY,
      twist: Event.twist,

      pointerId: Event.pointerId,
      pointerType: Event.pointerType,
      isPrimary: Event.isPrimary,

      width: Event.width,
      height: Event.height,

      key: Event.key,
      code: Event.code,
      location: Event.location,
      repeat: Event.repeat,
      ctrlKey: Event.ctrlKey,
      shiftKey: Event.shiftKey,
      altKey: Event.altKey,
      metaKey: Event.metaKey,

      deltaX: Event.deltaX,
      deltaY: Event.deltaY,
      deltaZ: Event.deltaZ,
      deltaMode: Event.deltaMode,

      inputType: Event.inputType,
      data: Event.data,

      duration: Event.duration,
      currentTime: Event.currentTime,

      message: Event.message,
      filename: Event.filename,
      lineno: Event.lineno,
      colno: Event.colno,

      clipboardData: Event.clipboardData,
    }
    Module.NekoEvents[Arguments[0] + "$" + Arguments[2]] = EventData
  })
]=])

local CompiledGetEvents = Neko:LoadString([=[
  const Events = JSON.stringify(Module.NekoEvents)
  Module.NekoEvents = {}
  return Events
]=])

function EventModule.new(Element, EventName, JavascriptEventName, LuaToJavascript)
	AllElements[Element.UniqueId] = {
		Instance = Element,
		LuaToJavascriptEventTable = LuaToJavascript,
	}
	CompiledAddEventListener(Element.UniqueId, JavascriptEventName, EventName)
	return Signal.new()
end

function EventModule:ProcessEvents()
	local Events = JSONService:Decode(CompiledGetEvents())

	for EventKey, EventArguments in pairs(Events) do
		local ElementId, EventName = table.unpack(LString.split(EventKey, "$"))
		local Element = AllElements[ElementId]
		local Arguments = {}

		for LuaProperty, JavascriptProperty in pairs(Element.LuaToJavascriptEventTable) do
			Arguments[LuaProperty] = EventArguments[JavascriptProperty]
		end

		Element.Instance[EventName]:Fire(Arguments)
	end
end

return EventModule
