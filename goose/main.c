#include <stdio.h>

#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"

int Main() {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  if (luaL_dofile(L, "main.lua") != LUA_OK) {
    printf("[Goose] Lua error: %s\n", lua_tostring(L, -1));
  }

  lua_close(L);
  return 0;
}
