set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm64)

set(XTOOLS_ROOT ${CMAKE_CURRENT_LIST_DIR}/../../x-tools/aarch64-linux-gnu)
set(CMAKE_C_COMPILER ${XTOOLS_ROOT}/bin/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER ${XTOOLS_ROOT}/bin/aarch64-linux-gnu-g++)
set(CMAKE_ASM_COMPILER ${XTOOLS_ROOT}/bin/aarch64-linux-gnu-gcc)
set(CMAKE_SYSROOT ${XTOOLS_ROOT}/aarch64-linux-gnu/sysroot)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
