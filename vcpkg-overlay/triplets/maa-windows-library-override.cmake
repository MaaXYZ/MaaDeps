set(VCPKG_LIBRARY_LINKAGE static)

if(PORT MATCHES "^opencv")
  set(VCPKG_LIBRARY_LINKAGE dynamic)
  list(APPEND VCPKG_CMAKE_CONFIGURE_OPTIONS
    -DBUILD_opencv_ml=OFF
    -DBUILD_opencv_stitching=OFF
    -DBUILD_opencv_objdetect=OFF
    -DBUILD_opencv_photo=OFF
    -DBUILD_opencv_video=OFF
    -DBUILD_opencv_apps=OFF
    -DBUILD_opencv_java_bindings_generator=OFF
    -DBUILD_opencv_js_bindings_generator=OFF
    -DBUILD_opencv_objc_bindings_generator=OFF
    -DBUILD_opencv_python_bindings_generator=OFF
    -DBUILD_opencv_python_tests=OFF
    -DBUILD_opencv_hdf=OFF
    -DBUILD_opencv_quality=OFF
    -DBUILD_TESTS=OFF
    -DBUILD_PERF_TESTS=OFF
    -DBUILD_EXAMPLES=OFF
    -DBUILD_DOCS=OFF
  )
endif()

if(PORT STREQUAL "openvino")
  # OpenVINO 静态链接进 ORT provider 时 DllMain 初始化失败 (Win32 1114)，
  # 与官方发行版保持一致改为动态库
  set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

if(PORT STREQUAL "tbb")
  # 与官方 OpenVINO 一致：动态 TBB，避免 OpenVINO 核心与 NPU 插件各自静态链接一份 TBB 导致崩溃
  set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

if(PORT STREQUAL "maa-onnxruntime")
  set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

if(PORT STREQUAL "maa-fastdeploy")
  set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

if(PORT STREQUAL "openvino" OR PORT STREQUAL "tbb")
  # OpenVINO 内部组件（前端、NPU compiler）按固定名 tbb12.dll / openvino*.dll 相互依赖，必须保持默认库名
else()
  set(VCPKG_CMAKE_CONFIGURE_OPTIONS
    ${VCPKG_CMAKE_CONFIGURE_OPTIONS}
    -DCMAKE_SHARED_LIBRARY_SUFFIX_CXX=_maa.dll
  )
endif()

string(APPEND VCPKG_CXX_FLAGS " /Zc:inline")
string(APPEND VCPKG_C_FLAGS " /Zc:inline")
string(APPEND VCPKG_LINKER_FLAGS " /cgthreads:4 /INCREMENTAL:NO")



