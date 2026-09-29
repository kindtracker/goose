#!/bin/bash
set -e

CFlags="-O3"
LDFlags="-sWASM=2"
Jobs="$(nproc)"

rm -rf build
mkdir build
mkdir build/lua
mkdir build/luasocket
mkdir build/luafilesystem
mkdir build/neko

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

CompileNeko() {
  File="$1"
  Object="build/neko/$(echo "$File" | sed 's#/#_#g; s#\.c$#.o#')"

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
export -f CompileNeko
export CFlags

find neko -name "*.c" |
  xargs -P "$Jobs" -n 1 bash -c 'CompileNeko "$1"' _

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

echo "  LD  web/nekol/wneko.js"
emcc $CFlags $LDFlags \
  build/lua/*.o build/neko/*.o \
  build/luasocket/*.o \
  build/luafilesystem/*.o \
  -sEXPORTED_FUNCTIONS=_Main \
  -sASYNCIFY=1 \
  -o web/nekol/wneko.js

lua bundle.lua
