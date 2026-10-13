# Android library overrides

# The non-legacy Android toolchain can shadow CMake's default Release flags.
# Supply them for every dependency, not just ORT (whose workaround was removed in #23688).
string(APPEND VCPKG_C_FLAGS_RELEASE " -O3 -DNDEBUG")
string(APPEND VCPKG_CXX_FLAGS_RELEASE " -O3 -DNDEBUG")

# Included triplet files must participate in the package ABI to invalidate old binaries.
list(APPEND VCPKG_HASH_ADDITIONAL_FILES
  "${CMAKE_CURRENT_LIST_FILE}"
  "${CMAKE_CURRENT_LIST_DIR}/maa-linux-library-override.cmake")

# ncnn is shared by MaaFramework and downstream agents (e.g. MaaEnd cpp-algo),
# so ship it as libncnn.so to keep a single copy of the runtime and its OpenMP state.
if(PORT STREQUAL "ncnn")
  message("setting dynamic linkage for ${PORT}")
  set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()
