[Clipper](http://www.angusj.com/delphi/clipper.php) FFI binding for LuaJit

Inspired by https://luapower.com/clipper

> Only macos binary (Windows/Linux build are planned)

# Install as a plug-in

Copy one of the pre-build binaries and the Lua module `src/clipper.lua` to your project. On Linux/MacOS you'll probably have to set `LD_LIBRARY_PATH` or `DYLD_LIBRARY_PATH` to the path where you copied the binary.

# Path offset example

```Lua
clipper = require 'clipper'

local path = clipper.Path()
path:add(10,20)
path:add(50,20)
path:add(50,50)

local co = clipper.ClipperOffset()
local out = co:offsetPath(path,10,'miter','openButt')

for i=1,out:size() do
  ...
end
```

# Build the shared library

```
mkdir src/build
cd src/build
cmake ../src
make
```

# Run the tests

```
cd src
./run.sh
```

# Run the specs

```
cd specs
./run-tests.sh
```

# Requirements

* CMake (build)
* LuaJit (tests)
* Love (tests)

# TODO

Set CMake's MACOSX_RPATH for macosx build
