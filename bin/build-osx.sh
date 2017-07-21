#!/bin/sh

if ! [ -d "src/build" ]; then
  mkdir -p "src/build"
fi

build=Release

pushd src/build
# Generate build system using the "XCode" or "Unix Makefiles" generator.
# cmake -G "Xcode" \
cmake -G "Unix Makefiles" \
    -DBUILD_OSX=TRUE \
    -DCMAKE_BUILD_TYPE=$build \
    ..

cmake --build . --target install --config $build
popd
