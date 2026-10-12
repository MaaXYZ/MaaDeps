# Android library overrides

# ncnn is shared by MaaFramework and downstream agents (e.g. MaaEnd cpp-algo),
# so ship it as libncnn.so to keep a single copy of the runtime and its OpenMP state.
if(PORT STREQUAL "ncnn")
  message("setting dynamic linkage for ${PORT}")
  set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()
