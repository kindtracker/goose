#!/bin/bash
set -e

CFlags="-O0"
Jobs="$(nproc)"

rm -rf build
mkdir build
mkdir build/lua
mkdir build/goose

compile_lua() {
  File="$1"
  Object="build/lua/$(echo "$File" | sed 's#/#_#g; s#\.c$#.o#')"

  echo "  CC  $File"
  emcc $CFlags -c "$File" \
    -Ilua \
    -o "$Object"
}

compile_goose() {
  File="$1"
  Object="build/goose/$(echo "$File" | sed 's#/#_#g; s#\.c$#.o#')"

  echo "  CC  $File"
  emcc $CFlags -c "$File" \
    -Ilua \
    -o "$Object"
}

export -f compile_lua
export -f compile_goose
export CFlags

find lua -name "*.c" \
  ! -name "onelua.c" \
  ! -name "lua.c" \
  ! -name "lib*.c" |
  xargs -P "$Jobs" -n 1 bash -c 'compile_lua "$1"' _

find goose -name "*.c" |
  xargs -P "$Jobs" -n 1 bash -c 'compile_goose "$1"' _

echo "  LD  web/goose.js"
emcc $CFlags build/lua/*.o build/goose/*.o \
  -Ilua \
  -sEXPORTED_FUNCTIONS=_Main \
  -o web/goose.js

rm -rf web/lunar
cp -r lunar/package web/lunar
