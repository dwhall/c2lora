cd embeddedartistry
git submodule update --init --recursive
rmdir /S /Q build
mkdir build
cd build
cmake .. -G Ninja -DCMAKE_TOOLCHAIN_FILE="../ea-toolchain.cmake" DLIBC_BUILD_MATH=ON
ninja