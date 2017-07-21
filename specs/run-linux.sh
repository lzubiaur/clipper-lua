#!/bin/sh

export LUA_PATH="./?.lua;../src/?.lua;;"
# export LUA_CPATH=""
# export PATH=""

export LD_LIBRARY_PATH=../bin/linux:$LD_LIBRARY_PATH

pushd specs
luajit tests.lua $*
popd
