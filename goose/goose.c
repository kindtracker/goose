#include <emscripten.h>

#include "lauxlib.h"
#include "lua.h"

#include "goose.h"

EM_JS(int, GooseCompileJavaScript, (char *String), {
  String = UTF8ToString(String);
  const CompFunction = new Function(String);

  if (!Module.GooseFunctions) {
    Module.GooseFunctions = new Map();
  }

  const Id = Module.GooseFunctions.size + 1;
  Module.GooseFunctions.set(Id, CompFunction);

  return Id;
});

EM_JS(char *, GooseCallJavaScript, (int Id), {
  const CompFunction = Module.GooseFunctions.get(Id);
  const ReturnString = String(CompFunction());

  const Length = lengthBytesUTF8(ReturnString) + 1;
  const Pointer = _malloc(Length);

  stringToUTF8(ReturnString, Pointer, Length);

  return Pointer;
});

int GooseLoadStringCall(lua_State *Lua) {
  int *Id = luaL_checkudata(Lua, 1, "GooseCompFunction");
  char *ReturnString = GooseCallJavaScript(*Id);
  lua_pushstring(Lua, ReturnString);

  return 1;
}

int GooseLoadString(lua_State *Lua) {
  const char *String = luaL_checkstring(Lua, 2);
  int *Id = lua_newuserdatauv(Lua, sizeof(int), 0);
  *Id = GooseCompileJavaScript(String);
  luaL_setmetatable(Lua, "GooseCompFunction");

  return 1;
}

int GooseLuaGlobal(lua_State *Lua) {
  luaL_newmetatable(Lua, "GooseCompFunction");
  lua_pushcfunction(Lua, GooseLoadStringCall);
  lua_setfield(Lua, -2, "__call");
  lua_pop(Lua, 1);

  lua_newtable(Lua);
  lua_pushcfunction(Lua, GooseLoadString);
  lua_setfield(Lua, -2, "LoadString");
  lua_setglobal(Lua, "Goose");

  return 0;
}
