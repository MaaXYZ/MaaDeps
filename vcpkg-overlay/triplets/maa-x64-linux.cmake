set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_BUILD_TYPE release)
set(VCPKG_CMAKE_SYSTEM_NAME Linux)

include(${CMAKE_CURRENT_LIST_DIR}/maa-linux-library-override.cmake)
