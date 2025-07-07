set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(XTOOLS_ROOT ${CMAKE_CURRENT_LIST_DIR}/../../x-tools/x86_64-linux-gnu)
set(CMAKE_C_COMPILER ${XTOOLS_ROOT}/bin/x86_64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER ${XTOOLS_ROOT}/bin/x86_64-linux-gnu-g++)
set(CMAKE_ASM_COMPILER ${XTOOLS_ROOT}/bin/x86_64-linux-gnu-gcc)
set(CMAKE_SYSROOT ${XTOOLS_ROOT}/x86_64-linux-gnu/sysroot)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC --sysroot=${CMAKE_SYSROOT}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC --sysroot=${CMAKE_SYSROOT}")
