@echo off

if not exist src\build (
  mkdir src\build
)

set PATH=.;C:\Users\lzubiaur\cmake-3.3.2\bin;%PATH% 
set BUILD_TYPE=Release

pushd src\build
cmake.exe -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -DBUILD_WIN32=TRUE ..
cmake.exe --build . --target install --config %BUILD_TYPE%
popd
