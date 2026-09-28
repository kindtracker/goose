#include <emscripten.h>

#include "lauxlib.h"
#include "lua.h"

#include "goose.h"

EM_JS(int, GooseCompileJavaScript, (char *String), {
  String = UTF8ToString(String);
  const CompFunction = new Function("Arguments", String);

  if (!Module.GooseFunctions) {
    Module.GooseFunctions = new Map();
  }

  const Id = Module.GooseFunctions.size + 1;
  Module.GooseFunctions.set(Id, CompFunction);

  return Id;
});

EM_JS(char *, GooseCallJavaScript, (int Id, char *ArgumentsJson), {
  const CompFunction = Module.GooseFunctions.get(Id);

  const Arguments = JSON.parse(UTF8ToString(ArgumentsJson));
  const ReturnString = String(CompFunction(Arguments));

  const Length = lengthBytesUTF8(ReturnString) + 1;
  const Pointer = _malloc(Length);

  stringToUTF8(ReturnString, Pointer, Length);

  return Pointer;
});

EM_JS(void, GooseCallJavaScriptVoid, (int Id, char *ArgumentsJson), {
  const CompFunction = Module.GooseFunctions.get(Id);

  const Arguments = JSON.parse(UTF8ToString(ArgumentsJson));
  CompFunction(Arguments);
});

void GooseAddJsonString(luaL_Buffer *Buffer, const char *Value) {
  luaL_addchar(Buffer, '"');

  for (const unsigned char *p = (const unsigned char *)Value; *p; p++) {
    switch (*p) {
    case '"':
      luaL_addstring(Buffer, "\\\"");
      break;

    case '\\':
      luaL_addstring(Buffer, "\\\\");
      break;

    case '\b':
      luaL_addstring(Buffer, "\\b");
      break;

    case '\f':
      luaL_addstring(Buffer, "\\f");
      break;

    case '\n':
      luaL_addstring(Buffer, "\\n");
      break;

    case '\r':
      luaL_addstring(Buffer, "\\r");
      break;

    case '\t':
      luaL_addstring(Buffer, "\\t");
      break;

    default:
      if (*p < 0x20) {
        char Escape[7];
        snprintf(Escape, sizeof(Escape), "\\u%04x", *p);
        luaL_addstring(Buffer, Escape);
      } else {
        luaL_addchar(Buffer, *p);
      }
      break;
    }
  }

  luaL_addchar(Buffer, '"');
}

int GooseLoadStringCall(lua_State *Lua) {
  int *Id = luaL_checkudata(Lua, 1, "GooseCompiledFunction");

  int ArgumentCount = lua_gettop(Lua) - 1;

  luaL_Buffer Buffer;
  luaL_buffinit(Lua, &Buffer);

  luaL_addchar(&Buffer, '[');

  for (int i = 0; i < ArgumentCount; i++) {
    if (i > 0) {
      luaL_addchar(&Buffer, ',');
    }

    const char *Value = luaL_checkstring(Lua, i + 2);
    GooseAddJsonString(&Buffer, Value);
  }

  luaL_addchar(&Buffer, ']');
  luaL_pushresult(&Buffer);

  const char *ArgumentsJson = lua_tostring(Lua, -1);
  char *ReturnString = GooseCallJavaScript(*Id, (char *)ArgumentsJson);
  lua_pop(Lua, 1);

  lua_pushstring(Lua, ReturnString);
  return 1;
}

int GooseLoadStringVoidCall(lua_State *Lua) {
  int *Id = luaL_checkudata(Lua, 1, "GooseCompiledVoidFunction");

  int ArgumentCount = lua_gettop(Lua) - 1;

  luaL_Buffer Buffer;
  luaL_buffinit(Lua, &Buffer);

  luaL_addchar(&Buffer, '[');

  for (int i = 0; i < ArgumentCount; i++) {
    if (i > 0)
      luaL_addchar(&Buffer, ',');

    const char *Value = luaL_checkstring(Lua, i + 2);
    GooseAddJsonString(&Buffer, Value);
  }

  luaL_addchar(&Buffer, ']');
  luaL_pushresult(&Buffer);

  const char *ArgumentsJson = lua_tostring(Lua, -1);

  GooseCallJavaScriptVoid(*Id, (char *)ArgumentsJson);

  lua_pop(Lua, 1);
  return 0;
}

int GooseLoadString(lua_State *Lua) {
  const char *String = luaL_checkstring(Lua, 2);
  int *Id = lua_newuserdatauv(Lua, sizeof(int), 0);
  *Id = GooseCompileJavaScript(String);
  luaL_setmetatable(Lua, "GooseCompiledFunction");

  return 1;
}

int GooseLoadStringVoid(lua_State *Lua) {
  const char *String = luaL_checkstring(Lua, 2);
  int *Id = lua_newuserdatauv(Lua, sizeof(int), 0);
  *Id = GooseCompileJavaScript(String);
  luaL_setmetatable(Lua, "GooseCompiledVoidFunction");

  return 1;
}

int GooseYield(lua_State *Lua) {
  emscripten_sleep(0);

  return 0;
}

int GooseLuaGlobal(lua_State *Lua) {
  luaL_newmetatable(Lua, "GooseCompiledFunction");
  lua_pushcfunction(Lua, GooseLoadStringCall);
  lua_setfield(Lua, -2, "__call");
  lua_pop(Lua, 1);

  luaL_newmetatable(Lua, "GooseCompiledVoidFunction");
  lua_pushcfunction(Lua, GooseLoadStringVoidCall);
  lua_setfield(Lua, -2, "__call");
  lua_pop(Lua, 1);

  lua_newtable(Lua);
  lua_pushcfunction(Lua, GooseLoadString);
  lua_setfield(Lua, -2, "LoadString");
  lua_pushcfunction(Lua, GooseLoadStringVoid);
  lua_setfield(Lua, -2, "LoadStringVoid");
  lua_pushcfunction(Lua, GooseYield);
  lua_setfield(Lua, -2, "Yield");
  lua_setglobal(Lua, "Goose");

  return 0;
}
