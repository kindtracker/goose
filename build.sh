#!/bin/bash
set -e

CFlags="-O0"
LDFlags="-sWASM=0"
Jobs="$(nproc)"

rm -rf build
mkdir build
mkdir build/lua
mkdir build/luasocket
mkdir build/luafilesystem
mkdir build/goose

CompileLua() {
  File="$1"
  Object="build/lua/$(echo "$File" | sed 's#/#_#g; s#\.c$#.o#')"

  echo "  CC  $File"
  emcc $CFlags -c "$File" \
    -Ivendors/lua \
    -o "$Object"
}

CompileLuaFileSystem() {
  File="$1"
  Object="build/luafilesystem/$(echo "$File" | sed 's#/#_#g; s#\.c$#.o#')"

  echo "  CC  $File"
  emcc $CFlags -c "$File" \
    -Ivendors/lua \
    -o "$Object"
}

CompileLuaSocket() {
  File="$1"
  Object="build/luasocket/$(echo "$File" | sed 's#/#_#g; s#\.c$#.o#')"

  echo "  CC  $File"
  emcc $CFlags -c "$File" \
    -Ivendors/lua \
    -DluaL_checkint=luaL_checkinteger \
    -o "$Object"
}

CompileGoose() {
  File="$1"
  Object="build/goose/$(echo "$File" | sed 's#/#_#g; s#\.c$#.o#')"

  echo "  CC  $File"
  emcc $CFlags -c "$File" \
    -Ivendors/luafilesystem/src \
    -Ivendors/luasocket/csrc/socket/src \
    -Ivendors/lua \
    -o "$Object"
}

export -f CompileLua
export -f CompileLuaFileSystem
export -f CompileLuaSocket
export -f CompileGoose
export CFlags

find goose -name "*.c" |
  xargs -P "$Jobs" -n 1 bash -c 'CompileGoose "$1"' _

find vendors/lua -name "*.c" \
  ! -name "onelua.c" \
  ! -name "lua.c" \
  ! -name "lib*.c" |
  xargs -P "$Jobs" -n 1 bash -c 'CompileLua "$1"' _

find vendors/luafilesystem -name "*.c" |
  xargs -P "$Jobs" -n 1 bash -c 'CompileLuaFileSystem "$1"' _

find vendors/luasocket -name "*.c" \
  ! -name "wsocket.c" \
  ! -name "serial.c" |
  xargs -P "$Jobs" -n 1 bash -c 'CompileLuaSocket "$1"' _

echo "  LD  web/goosel/wgoose.js"
emcc $CFlags $LDFlags \
  build/lua/*.o build/goose/*.o \
  build/luasocket/*.o \
  build/luafilesystem/*.o \
  -sEXPORTED_FUNCTIONS=_Main \
  -o web/goosel/wgoose.js

rm -rf web/goosel/vendors
mkdir web/goosel/vendors
cp -r vendors/lunar/package web/goosel/vendors/lunar
cp -r vendors/luasocket/socket web/goosel/vendors/luasocket
cp vendors/luasocket/*.lua web/goosel/vendors/luasocket
cp -r vendors/luamimetypes web/goosel/vendors/luamimetypes
