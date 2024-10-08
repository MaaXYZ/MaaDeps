import os
import sys
from pathlib import Path
import subprocess
import shutil
from .common import resdir
from . import runtime_linux as linux
from .vcpkg import triplet

exclude = [
    "*onnxruntime_providers_shared*",
    "*opencv_img_hash*",
]

def set_rpath(file, rpath):
    linux.set_rpath(file, rpath)

def split_debug(file, debug_file):
    temp_debug_file = Path(file).parent / Path(debug_file).name
    android_ndk = os.environ.get("ANDROID_NDK_HOME", "/opt/android-ndk")
    ndk_which = os.path.join(android_ndk, "ndk-which")
    objcopy = subprocess.check_output([ndk_which, "objcopy"]).decode().strip()
    objcopy = os.environ.get("OBJCOPY", objcopy)
    subprocess.check_call([objcopy, "--only-keep-debug", "--", file, temp_debug_file])
    shutil.move(temp_debug_file, debug_file)

def is_elf(file):
    return linux.is_elf(file)

def get_soname(file):
    return linux.get_soname(file)

def install_runtime(target, debug):
    from . import vcpkg
    prefix = Path(vcpkg.install_prefix)
    target = Path(target)
    from .runtime import install_file, match_patterns
    for file in prefix.glob("lib/**/*"):
        if (match_patterns(file, exclude)):
            continue
        if file.is_symlink() or not file.is_file():
            continue
        if is_elf(file):
            soname = get_soname(file)
            if soname is not None:
                target_path = target / soname
            else:
                target_path = target / file.name
            install_file(file, target_path)
            set_rpath(target_path, '$ORIGIN')
            split_debug(target_path, Path(debug, target_path.name + '.debug'))


    print("Installing libc++_shared.so for Android")
    android_ndk = os.environ.get("ANDROID_NDK_HOME", "/opt/android-ndk")

    if sys.platform == "win32" or sys.platform == "cygwin":
        host = "windows-x86_64"
    elif sys.platform == "linux":
        host = "linux-x86_64"
    elif sys.platform == "darwin":
        host = "darwin-x86_64"

    if "arm64" in triplet:
        runtime = "aarch64-linux-android"
    elif "arm" in triplet:
        runtime = "arm-linux-androideabi"
    elif "x64" in triplet:
        runtime = "x86_64-linux-android"

    libcxx_shared = os.path.join(android_ndk, f"toolchains/llvm/prebuilt/{host}/sysroot/usr/lib/{runtime}/libc++_shared.so")
    install_file(libcxx_shared, target / "libc++_shared.so")
