[Clipper](http://www.angusj.com/delphi/clipper.php) (v6.4.2) FFI binding for LuaJIT.

Inspired by https://luapower.com/clipper


# Polygon clipping example

```Lua
local p1 = clipper.Path()
p1:add(100,100)
p1:add(150,100)
p1:add(150,150)
p1:add(100,150)

local p2 = clipper.Path()
p2:add(100,120)
p2:add(150,120)
p2:add(150,130)
p2:add(100,130)

local cl = clipper.Clipper()
cl:addPath(p1,'subject')
cl:addPath(p2,'clip')
local out = cl:execute('difference')
```

# Path offset example

```Lua
clipper = require 'clipper'

local path = clipper.Path()
path:add(10,20)
path:add(50,20)
path:add(50,50)

local co = clipper.ClipperOffset()
local out = co:offsetPath(path,10,'miter','openButt')
```

# References

TODO

# Install as a shared library (plug-in)

Copy one of the pre-build binaries and the Lua module `src/clipper.lua` to your project. On Linux/MacOS you'll probably have to set `LD_LIBRARY_PATH` or `DYLD_LIBRARY_PATH` to the path where you installed the binary.

# Build as a static library

On *Android* build the source as a static library and then include the module to the main executable using `LOCAL_WHOLE_STATIC_LIBRARIES` so all symbols are exported.

# Build the shared libraries

Clone this repo and run the build scripts for your target platform.

```
git clone https://github.com/lzubiaur/clipper-binding
cd clipper-binding
bin/build-osx.sh
```

# Run the tests

```
./tests/run-tests.sh
```

# Run the specs

Run the specs script from the project root.

```
./specs/run.sh
```

# Requirements

* CMake (build)
* Xcode (osx build)
* VisualStudio (win build)
* LuaJit (tests)
* Love2D (tests)

# Notes

* Only Path(s) clipping/offseting (not PolyTree)
* Only macos binary (Windows/Linux build are planned)

Not implemented/binded
* ReversePaths (but ReversePath is)
* SimplifyPolygons (but SimplifyPolygon is)
* CleanPolygons (but CleanPolygon is)
* Clipper.ZFillFunction
* MinkowskiDiff/Sum
* PolyTree related functions (OpenPathsFromPolyTree, ClosedPathsFromPolyTree, PolyTreeToPaths)
* OffsetPaths (deprecated)

# TODO

* CleanPolygon(s)
* Set CMake's MACOSX_RPATH for macosx build
* Uncomment use_int32 to improve performance?
