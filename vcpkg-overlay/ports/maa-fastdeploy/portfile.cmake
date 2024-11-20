vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MaaXYZ/FastDeploy
    REF ecd60dfeac3474f8bb00d4eb89ad2bf1a69802f2
    SHA512 f077ed0ed5faca43e3e943e7cc401c7dabb22e3b41a6728010e81de794919ef74db0f0643a36c2eec92aadf2b30ed276c3c63061757a19f08bcc761a62a74608
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME fastdeploy_ppocr CONFIG_PATH share/fastdeploy_ppocr)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
