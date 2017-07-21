#!/bin/bash

if ! [ -d "src/build" ]; then
  mkdir -p "src/build"
fi
pushd src/build

cmake \
    -DBUILD_LINUX=TRUE \
    -DCMAKE_BUILD_TYPE=Release \
    ..

cmake --build . --target install --config Release
popd
