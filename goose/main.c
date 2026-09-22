#include <stdio.h>

#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"

#include "lfs.h"
#include "luasocket.h"
#include "mime.h"

int Main() {
  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  luaL_requiref(L, "lfs", luaopen_lfs, 1);
  lua_pop(L, 1);

  luaL_requiref(L, "socket.core", luaopen_socket_core, 1);
  lua_pop(L, 1);

  luaL_requiref(L, "mime.core", luaopen_mime_core, 1);
  lua_pop(L, 1);

  lua_getglobal(L, "package");
  lua_getfield(L, -1, "path");
  const char *Path = lua_tostring(L, -1);
  lua_pop(L, 1);

  lua_pushfstring(L,
                  "%s;/usr/local/share/lua/5.5/lunar/vendors/?.lua;/usr/local/"
                  "share/lua/5.5/lunar/vendors/?/init.lua",
                  Path);
  lua_setfield(L, -2, "path");
  lua_pop(L, 1);

  if (luaL_dofile(L, "main.lua") != LUA_OK) {
    printf("[Goose] Lua error: %s\n", lua_tostring(L, -1));
  }

  lua_close(L);
  return 0;
}
