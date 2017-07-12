#!/bin/sh

# export LUA_PATH=""
# export LUA_CPATH=""
# export PATH=""

export LD_LIBRARY_PATH=./build:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=./build:$DYLD_LIBRARY_PATH

love .
