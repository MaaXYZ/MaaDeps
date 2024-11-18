vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MaaXYZ/FastDeploy
    REF 1ee2cf3f66aaed77b8a3499358cd51988d8ed75b
    SHA512 691143223e41049a2e5a86f624175d187a60fa46d8ab42efb3c38239eb7239026f2ef8b268d7ed8383de9bca6aa81726cd595a4671a4dab80f28879e0fdb9f1a
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME fastdeploy_ppocr CONFIG_PATH share/fastdeploy_ppocr)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
