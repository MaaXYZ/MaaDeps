vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MaaXYZ/FastDeploy
    REF 04d5e29954cf55a4c5eefee973762b4b069e6304
    SHA512 56490f29a5dd326620b5f9a51c74cf8c1944685fcf550f56491c27ef51a4eeaa39934f0f2eba5789dd9ebd8e8f0ffe3bcb1d2a1f8103cf1629f79a9b5066b33f
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME fastdeploy_ppocr CONFIG_PATH share/fastdeploy_ppocr)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
