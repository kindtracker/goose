#!/bin/bash
set -e

CFlags="-O0"
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
    -Ilua \
    -o "$Object"
}

CompileLuaFileSystem() {
  File="$1"
  Object="build/luafilesystem/$(echo "$File" | sed 's#/#_#g; s#\.c$#.o#')"

  echo "  CC  $File"
  emcc $CFlags -c "$File" \
    -Ilua \
    -o "$Object"
}

CompileLuaSocket() {
  File="$1"
  Object="build/luasocket/$(echo "$File" | sed 's#/#_#g; s#\.c$#.o#')"

  echo "  CC  $File"
  emcc $CFlags -c "$File" \
    -Ilua \
    -DluaL_checkint=luaL_checkinteger \
    -o "$Object"
}

CompileGoose() {
  File="$1"
  Object="build/goose/$(echo "$File" | sed 's#/#_#g; s#\.c$#.o#')"

  echo "  CC  $File"
  emcc $CFlags -c "$File" \
    -Iluafilesystem/src -Iluasocket/csrc/socket/src \
    -Ilua \
    -o "$Object"
}

export -f CompileLua
export -f CompileLuaFileSystem
export -f CompileLuaSocket
export -f CompileGoose
export CFlags

find lua -name "*.c" \
  ! -name "onelua.c" \
  ! -name "lua.c" \
  ! -name "lib*.c" |
  xargs -P "$Jobs" -n 1 bash -c 'CompileLua "$1"' _

find luafilesystem -name "*.c" |
  xargs -P "$Jobs" -n 1 bash -c 'CompileLuaFileSystem "$1"' _

find luasocket -name "*.c" \
  ! -name "wsocket.c" \
  ! -name "serial.c" |
  xargs -P "$Jobs" -n 1 bash -c 'CompileLuaSocket "$1"' _

find goose -name "*.c" |
  xargs -P "$Jobs" -n 1 bash -c 'CompileGoose "$1"' _

echo "  LD  web/goose.js"
emcc $CFlags \
  build/lua/*.o build/goose/*.o \
  build/luasocket/*.o \
  build/luafilesystem/*.o \
  -sEXPORTED_FUNCTIONS=_Main \
  -o web/goose.js

rm -rf web/lunar
cp -r lunar/package web/lunar
cp -r luasocket/socket web/luasocket
cp luasocket/*.lua web/luasocket
