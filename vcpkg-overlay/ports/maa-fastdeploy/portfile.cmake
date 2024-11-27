vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO MaaXYZ/FastDeploy
    REF 95b3aee6ed62cd0bf8c6e74a290c5db9452e2c41
    SHA512 77572b5490e40c8aee740640f3d96e8c76494a2aefb286b2f8608295ad9adb7931a03629389fbf99370808fae0165e63746844a581dca83415105c89aa2298e2
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME fastdeploy_ppocr CONFIG_PATH share/fastdeploy_ppocr)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
