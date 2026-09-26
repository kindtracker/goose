#include <stdio.h>

#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"

#include "lfs.h"
#include "luasocket.h"
#include "mime.h"

#include "goose.h"

int Main() {
  lua_State *Lua = luaL_newstate();
  luaL_openlibs(Lua);

  luaL_requiref(Lua, "lfs", luaopen_lfs, 1);
  lua_pop(Lua, 1);

  luaL_requiref(Lua, "socket.core", luaopen_socket_core, 1);
  lua_pop(Lua, 1);

  luaL_requiref(Lua, "mime.core", luaopen_mime_core, 1);
  lua_pop(Lua, 1);

  lua_getglobal(Lua, "package");
  lua_getfield(Lua, -1, "path");
  const char *Path = lua_tostring(Lua, -1);
  lua_pop(Lua, 1);

  lua_pushfstring(Lua,
                  "%s;/usr/local/share/lua/5.5/lunar/vendors/?.lua;/usr/local/"
                  "share/lua/5.5/lunar/vendors/?/init.lua",
                  Path);
  lua_setfield(Lua, -2, "path");
  lua_pop(Lua, 1);

  GooseLuaGlobal(Lua);

  if (luaL_dofile(Lua, "/gooselib/goose.lua") != LUA_OK) {
    printf("[Goose] Lua error: %s\n", lua_tostring(Lua, -1));
    return 1;
  }

  if (luaL_dofile(Lua, "main.lua") != LUA_OK) {
    printf("[Goose] Lua error: %s\n", lua_tostring(Lua, -1));
    return 1;
  }

  lua_close(Lua);
  return 0;
}
