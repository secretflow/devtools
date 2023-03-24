#! /usr/bin/bash

mkdir -pv build &&
      cd build &&
      cmake -DCMAKE_INSTALL_PREFIX=/usr/local \
            -DLLVM_ENABLE_PROJECTS="lld" \
            -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON \
            -DLLVM_ENABLE_EH=ON \
            -DLLVM_INCLUDE_DOCS=OFF \
            -DLLVM_INCLUDE_TESTS=OFF \
            -DLLVM_INSTALL_UTILS=OFF \
            -DLLVM_ENABLE_Z3_SOLVER=OFF \
            -DLLVM_OPTIMIZED_TABLEGEN=ON \
            -DLLDB_USE_SYSTEM_DEBUGSERVER=ON \
            -DLLDB_ENABLE_PYTHON=OFF \
            -DLLDB_ENABLE_LUA=OFF \
            -DLLDB_ENABLE_LZMA=ON \
            -DLLVM_ENABLE_FFI=ON \
            -DCMAKE_BUILD_TYPE=Release \
            -DLLVM_BUILD_LLVM_DYLIB=ON \
            -DLLVM_LINK_LLVM_DYLIB=ON \
            -DLLVM_ENABLE_RTTI=ON \
            -DLLVM_TARGETS_TO_BUILD="host" \
            -DLLVM_BUILD_TESTS=OFF \
            -Wno-dev -G Ninja .. &&
      ninja
      ninja install
