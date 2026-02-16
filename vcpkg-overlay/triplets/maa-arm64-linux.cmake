set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_BUILD_TYPE release)
set(VCPKG_CMAKE_SYSTEM_NAME Linux)
set(VCPKG_MAKE_BUILD_TRIPLET "--target=aarch64-linux-gnu")
if (PORT STREQUAL "pthread-stubs")
  set(VCPKG_MAKE_BUILD_TRIPLET "--host=x86_64-linux-gnu --target=x86_64-linux-gnu")
endif ()

set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/../../cmake/maa-arm64-linux-toolchain.cmake")

include(${CMAKE_CURRENT_LIST_DIR}/maa-linux-library-override.cmake)
