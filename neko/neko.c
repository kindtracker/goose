#include <emscripten.h>

#include "lauxlib.h"
#include "lua.h"

#include "neko.h"

EM_JS(int, NekoCompileJavaScript, (char *String), {
  String = UTF8ToString(String);
  const CompFunction = new Function("Arguments", String);

  if (!Module.NekoFunctions) {
    Module.NekoFunctions = new Map();
  }

  const Id = Module.NekoFunctions.size + 1;
  Module.NekoFunctions.set(Id, CompFunction);

  return Id;
});

EM_JS(char *, NekoCallJavaScript, (int Id, char *ArgumentsJson), {
  const CompFunction = Module.NekoFunctions.get(Id);

  const Arguments = JSON.parse(UTF8ToString(ArgumentsJson));
  const ReturnString = String(CompFunction(Arguments));

  const Length = lengthBytesUTF8(ReturnString) + 1;
  const Pointer = _malloc(Length);

  stringToUTF8(ReturnString, Pointer, Length);

  return Pointer;
});

EM_JS(void, NekoCallJavaScriptVoid, (int Id, char *ArgumentsJson), {
  const CompFunction = Module.NekoFunctions.get(Id);

  const Arguments = JSON.parse(UTF8ToString(ArgumentsJson));
  CompFunction(Arguments);
});

void NekoAddJsonString(luaL_Buffer *Buffer, const char *Value) {
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

int NekoLoadStringCall(lua_State *Lua) {
  int *Id = luaL_checkudata(Lua, 1, "NekoCompiledFunction");

  int ArgumentCount = lua_gettop(Lua) - 1;

  luaL_Buffer Buffer;
  luaL_buffinit(Lua, &Buffer);

  luaL_addchar(&Buffer, '[');

  for (int i = 0; i < ArgumentCount; i++) {
    if (i > 0) {
      luaL_addchar(&Buffer, ',');
    }

    const char *Value = luaL_checkstring(Lua, i + 2);
    NekoAddJsonString(&Buffer, Value);
  }

  luaL_addchar(&Buffer, ']');
  luaL_pushresult(&Buffer);

  const char *ArgumentsJson = lua_tostring(Lua, -1);
  char *ReturnString = NekoCallJavaScript(*Id, (char *)ArgumentsJson);
  lua_pop(Lua, 1);

  lua_pushstring(Lua, ReturnString);
  return 1;
}

int NekoLoadStringVoidCall(lua_State *Lua) {
  int *Id = luaL_checkudata(Lua, 1, "NekoCompiledVoidFunction");

  int ArgumentCount = lua_gettop(Lua) - 1;

  luaL_Buffer Buffer;
  luaL_buffinit(Lua, &Buffer);

  luaL_addchar(&Buffer, '[');

  for (int i = 0; i < ArgumentCount; i++) {
    if (i > 0)
      luaL_addchar(&Buffer, ',');

    const char *Value = luaL_checkstring(Lua, i + 2);
    NekoAddJsonString(&Buffer, Value);
  }

  luaL_addchar(&Buffer, ']');
  luaL_pushresult(&Buffer);

  const char *ArgumentsJson = lua_tostring(Lua, -1);

  NekoCallJavaScriptVoid(*Id, (char *)ArgumentsJson);

  lua_pop(Lua, 1);
  return 0;
}

int NekoLoadString(lua_State *Lua) {
  const char *String = luaL_checkstring(Lua, 2);
  int *Id = lua_newuserdatauv(Lua, sizeof(int), 0);
  *Id = NekoCompileJavaScript(String);
  luaL_setmetatable(Lua, "NekoCompiledFunction");

  return 1;
}

int NekoLoadStringVoid(lua_State *Lua) {
  const char *String = luaL_checkstring(Lua, 2);
  int *Id = lua_newuserdatauv(Lua, sizeof(int), 0);
  *Id = NekoCompileJavaScript(String);
  luaL_setmetatable(Lua, "NekoCompiledVoidFunction");

  return 1;
}

int NekoYield(lua_State *Lua) {
  emscripten_sleep(0);

  return 0;
}

int NekoLuaGlobal(lua_State *Lua) {
  luaL_newmetatable(Lua, "NekoCompiledFunction");
  lua_pushcfunction(Lua, NekoLoadStringCall);
  lua_setfield(Lua, -2, "__call");
  lua_pop(Lua, 1);

  luaL_newmetatable(Lua, "NekoCompiledVoidFunction");
  lua_pushcfunction(Lua, NekoLoadStringVoidCall);
  lua_setfield(Lua, -2, "__call");
  lua_pop(Lua, 1);

  lua_newtable(Lua);
  lua_pushcfunction(Lua, NekoLoadString);
  lua_setfield(Lua, -2, "LoadString");
  lua_pushcfunction(Lua, NekoLoadStringVoid);
  lua_setfield(Lua, -2, "LoadStringVoid");
  lua_pushcfunction(Lua, NekoYield);
  lua_setfield(Lua, -2, "Yield");
  lua_setglobal(Lua, "Neko");

  return 0;
}
