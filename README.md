[Clipper](http://www.angusj.com/delphi/clipper.php) FFI binding for LuaJit
Inspired by https://luapower.com/clipper

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
