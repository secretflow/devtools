#! /usr/bin/bash

mkdir -pv build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DLLVM_ENABLE_PROJECTS="lld" \
      -DLLVM_INCLUDE_UTILS=OFF \
      -DLLVM_INCLUDE_DOCS=OFF \
      -DLLVM_INCLUDE_TESTS=OFF \
      -DLLVM_ENABLE_EH=ON \
      -DLLVM_ENABLE_Z3_SOLVER=OFF \
      -DLLVM_OPTIMIZED_TABLEGEN=ON \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_TARGETS_TO_BUILD="host" \
      -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
      -DLLVM_ENABLE_RTTI=ON \
      -DPYTHON_EXECUTABLE=/bin/python3 \
      -Wno-dev -G Ninja .. &&
      ninja install

rm -r /usr/local/bin/llvm-*