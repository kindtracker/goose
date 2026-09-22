emcc $(find lua -name "*.c" \
  ! -name "onelua.c" \
  ! -name "lua.c" \
  ! -name "lib*.c") \
  -Ilua \
  -o web/goose.js
