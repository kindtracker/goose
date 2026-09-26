#!/bin/bash

rm -rf web/goosel/vendors
rm -rf web/goosel/gooselib
mkdir web/goosel/vendors
cp -r vendors/lunar/package web/goosel/vendors/lunar
cp -r gooselua web/goosel/gooselib
cp -r vendors/luasocket/socket web/goosel/vendors/luasocket
cp vendors/luasocket/*.lua web/goosel/vendors/luasocket
cp -r vendors/luamimetypes web/goosel/vendors/luamimetypes
