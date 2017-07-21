#!/bin/sh

export LUA_PATH="../src/?.lua;;"
export DYLD_LIBRARY_PATH=../bin/macosx-64:$DYLD_LIBRARY_PATH

pushd tests
love .
popd
