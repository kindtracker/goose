#!/bin/bash

while inotifywait -r -e modify,create,delete,move \
  neko build.sh; do
  ./build.sh
done
