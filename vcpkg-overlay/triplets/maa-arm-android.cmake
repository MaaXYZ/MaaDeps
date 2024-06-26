set(VCPKG_TARGET_ARCHITECTURE arm)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_CMAKE_SYSTEM_NAME Android)
set(VCPKG_CMAKE_SYSTEM_VERSION 23)
set(VCPKG_BUILD_TYPE release)
set(VCPKG_MAKE_BUILD_TRIPLET "--host=armv7a-linux-androideabi")
set(VCPKG_CMAKE_CONFIGURE_OPTIONS ${VCPKG_CMAKE_CONFIGURE_OPTIONS}
    -DANDROID_ABI=armeabi-v7a
    -DANDROID_USE_LEGACY_TOOLCHAIN_FILE=OFF
    -DCMAKE_SHARED_LINKER_FLAGS="-Wl,-s")

include(${CMAKE_CURRENT_LIST_DIR}/maa-linux-library-override.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/maa-android-library-override.cmake)
