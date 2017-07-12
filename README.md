Work in progress - Clipper FFI binding for LuaJit

Inspired by https://luapower.com/clipper

# Requirements to build and run the tests

* LuaJit
* CMake

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

# TODO

Set CMake's MACOSX_RPATH for macosx build
