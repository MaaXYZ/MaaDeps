set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CRT_LINKAGE dynamic)
set(VCPKG_BUILD_TYPE release)
set(VCPKG_CMAKE_SYSTEM_NAME Darwin)

set(VCPKG_OSX_ARCHITECTURES arm64)
set(VCPKG_OSX_DEPLOYMENT_TARGET 11.0)

string(APPEND VCPKG_C_FLAGS "-g -DNDEBUG")
string(APPEND VCPKG_CXX_FLAGS "-g -DNDEBUG")

include(${CMAKE_CURRENT_LIST_DIR}/maa-linux-library-override.cmake)

if(PORT MATCHES "onnxruntime")
    message("add -Wno-error for ${PORT}")
    string(APPEND VCPKG_C_FLAGS " -Wno-error=shorten-64-to-32")
    string(APPEND VCPKG_CXX_FLAGS " -Wno-error=shorten-64-to-32")
    string(APPEND VCPKG_C_FLAGS " -Wno-error=c99-extensions")
    string(APPEND VCPKG_CXX_FLAGS " -Wno-error=c99-extensions")
endif()
