#include "lua.h"

#include "goose.h"

int GooseLuaGlobal(lua_State *Lua) {
  lua_newtable(Lua);
  GoosePage(Lua);
  lua_setfield(Lua, -2, "Page");
  lua_setglobal(Lua, "Goose");

  return 0;
}
