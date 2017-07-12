#!/bin/sh

export LUA_PATH="./?.lua;../src/?.lua;;"
# export LUA_CPATH=""
# export PATH=""

export LD_LIBRARY_PATH=../src/build:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=../src/build:$DYLD_LIBRARY_PATH

luajit tests.lua $*
