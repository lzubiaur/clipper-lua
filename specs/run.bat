@echo off

setlocal
set LUA_PATH="./?.lua;../src/?.lua;;"

@rem Windows search for DLLs in the PATH environment variable
set PATH=..\bin\win;%PATH%

pushd specs
luajit tests.lua
popd
endlocal
