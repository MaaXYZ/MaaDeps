# if(PORT MATCHES "onnxruntime")
#     message("add -Wno-error=shorten-64-to-32 for ${PORT}")
#     string(APPEND VCPKG_C_FLAGS "-Wno-error=shorten-64-to-32")
#     string(APPEND VCPKG_CXX_FLAGS "-Wno-error=shorten-64-to-32")
# endif()
# if (PORT MATCHES "curl")
#     message("add -Wno-error=implicit-function-declaration for ${PORT}")
#     string(APPEND VCPKG_C_FLAGS "-Wno-error=implicit-function-declaration")
#     string(APPEND VCPKG_CXX_FLAGS "-Wno-error=implicit-function-declaration")
# endif()
