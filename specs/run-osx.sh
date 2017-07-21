#!/bin/sh

export LUA_PATH="./?.lua;../src/?.lua;;"
export DYLD_LIBRARY_PATH=../bin/macosx-64:$DYLD_LIBRARY_PATH

pushd specs
luajit tests.lua $*
popd
