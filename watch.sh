#!/bin/bash

while inotifywait -r -e modify,create,delete,move \
  goose build.sh; do
  ./build.sh
done
