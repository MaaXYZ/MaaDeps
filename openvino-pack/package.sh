#!/usr/bin/env bash
# 收集 Intel OpenVINO 加速包（Release 运行时，不含 PDB/Debug）。
# 用法: package.sh [--target <triplet>] [--runtime <dir>] [--with-maacore <MaaCore 路径>] [--out <输出目录>]
set -euo pipefail

MD="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="${TARGET:-maa-x64-windows}"
RT="${RT:-}"
OUT="$MD/openvino-pack/dist"
MAACORE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --target) TARGET="$2"; shift 2 ;;
        --runtime) RT="$2"; shift 2 ;;
        --with-maacore) MAACORE="$2"; shift 2 ;;
        --out) OUT="$2"; shift 2 ;;
        *) echo "unknown arg: $1" >&2; exit 1 ;;
    esac
done

if [[ -z "$RT" ]]; then
    for candidate in "$MD/openvino-pack/ci/runtime/$TARGET" "$MD/openvino-pack/ci/$TARGET" "$MD/runtime/$TARGET"; do
        if [[ -d "$candidate" ]]; then
            RT="$candidate"
            break
        fi
    done
fi
if [[ ! -d "$RT" ]]; then
    echo "runtime directory not found for $TARGET; pass --runtime <dir>" >&2
    exit 1
fi

# 全量重建输出目录，避免上一次打包的旧文件残留。
rm -rf "$OUT"
mkdir -p "$OUT"

copy_required() {
    local pattern="$1" dst_name="${2:-}"
    local matched=0
    for f in "$RT"/$pattern; do
        [[ -e "$f" ]] || continue
        if [[ -n "$dst_name" ]]; then
            cp -f "$f" "$OUT/$dst_name"
        else
            cp -f "$f" "$OUT/"
        fi
        matched=1
        break
    done
    if [[ "$matched" -eq 0 ]]; then
        echo "missing required runtime file: $RT/$pattern" >&2
        exit 1
    fi
}

copy_optional() {
    for f in "$RT"/$1; do
        [[ -e "$f" ]] && cp -f "$f" "$OUT/"
    done
    return 0
}

case "$TARGET" in
    *windows*)
        copy_required "onnxruntime_maa.dll"
        # 三元组可能给共享库追加 _maa 后缀；ORT 按固定名加载 provider，统一改回原名。
        copy_required "onnxruntime_providers_shared*.dll" "onnxruntime_providers_shared.dll"
        copy_required "onnxruntime_providers_openvino*.dll" "onnxruntime_providers_openvino.dll"
        copy_required "openvino.dll"
        copy_required "openvino_intel_cpu_plugin.dll"
        copy_required "openvino_intel_npu_plugin.dll"
        copy_required "openvino_intel_npu_compiler.dll"
        copy_required "openvino_onnx_frontend*.dll"
        copy_required "tbb12*.dll"
        copy_optional "onnxruntime_providers_webgpu*.dll"
        ;;
    *linux*)
        copy_required "libonnxruntime.so*"
        copy_required "*onnxruntime_providers_shared*"
        copy_required "*onnxruntime_providers_openvino*"
        copy_required "libopenvino.so*"
        copy_required "libopenvino_intel_cpu_plugin.so*"
        copy_required "libopenvino_onnx_frontend.so*"
        copy_optional "libopenvino_intel_npu_plugin.so*"
        copy_optional "libopenvino_intel_npu_compiler.so*"
        copy_optional "libtbb.so*"
        ;;
    *)
        echo "unsupported target: $TARGET" >&2
        exit 1
        ;;
esac

# 可选：OpenVINO 构建的 MaaCore（启用原生 OCR）
if [[ -n "$MAACORE" ]]; then
    if [[ ! -f "$MAACORE" ]]; then
        echo "MaaCore not found: $MAACORE" >&2
        exit 1
    fi
    case "$TARGET" in
        *windows*) cp -f "$MAACORE" "$OUT/MaaCore.dll" ;;
        *linux*) cp -f "$MAACORE" "$OUT/libMaaCore.so" ;;
    esac
fi

cp -f "$(dirname "$0")/README.md" "$OUT/" 2>/dev/null || true
cp -f "$(dirname "$0")/install.ps1" "$OUT/" 2>/dev/null || true

echo "pack contents:"
ls -lh "$OUT"
echo "output: $OUT"
