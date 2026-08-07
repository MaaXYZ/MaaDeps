set(VCPKG_LIBRARY_LINKAGE static)
# set(VCPKG_CMAKE_CONFIGURE_OPTIONS ${VCPKG_CMAKE_CONFIGURE_OPTIONS} -DCMAKE_SHARED_LIBRARY_SUFFIX_CXX=_maa.so)

if(PORT STREQUAL "opencv4")
  set(VCPKG_LIBRARY_LINKAGE dynamic)
  # Keep the statically linked JPEG implementation private to OpenCV.
  # --exclude-libs is GNU ld / LLVM lld only; Apple ld64 rejects it.
  set(VCPKG_CMAKE_CONFIGURE_OPTIONS ${VCPKG_CMAKE_CONFIGURE_OPTIONS} -DWITH_V4L=OFF)
  if(NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(VCPKG_CMAKE_CONFIGURE_OPTIONS ${VCPKG_CMAKE_CONFIGURE_OPTIONS}
        -DCMAKE_SHARED_LINKER_FLAGS=-Wl,--exclude-libs,libjpeg.a)
  endif()
endif()

if(PORT MATCHES "onnxruntime|maa-")
  message("setting dynamic linkage for ${PORT}")
  set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

if (PORT STREQUAL "opencv")
    list(APPEND VCPKG_CMAKE_CONFIGURE_OPTIONS -DBUILD_opencv_hdf=OFF -DBUILD_opencv_quality=OFF)
endif ()

if (PORT STREQUAL "wayland")
  set(X_VCPKG_FORCE_VCPKG_WAYLAND_LIBRARIES ON)
endif ()
