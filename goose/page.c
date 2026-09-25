#include <emscripten.h>
#include <lua.h>

#include "goose.h"

EM_JS(void, GoosePageSetTitle, (const char *Title),
      { document.title = UTF8ToString(Title); });

int GoosePageSetTitleLua(lua_State *Lua) {
  const char *Title = luaL_checkstring(Lua, 2);
  GoosePageSetTitle(Title);
  return 0;
}

int GoosePage(lua_State *Lua) {
  lua_newtable(Lua);
  lua_pushcfunction(Lua, GoosePageSetTitleLua);
  lua_setfield(Lua, -2, "SetTitle");
  return 0;
}
