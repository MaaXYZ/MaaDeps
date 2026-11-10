# MAA OpenVINO 加速包（实验性，外置）

可选组件，不随 MAA 主包分发。提供：

- ONNX Runtime（OpenVINO EP）
- OpenVINO 2026.1 运行时（CPU/NPU 插件、NPU compiler、ONNX 前端、TBB）
- 可选：OpenVINO 构建的 `MaaCore.dll`（启用原生 OpenVINO OCR）

## 构建依赖包

默认构建不包含 OpenVINO：

```bash
python build.py
```

构建加速包依赖：

```bash
python build.py --openvino
```

仅支持 Windows/Linux x64。产物位于 `runtime/maa-x64-windows`（Linux 为 `runtime/maa-x64-linux`）。

## 打包

```bash
bash openvino-pack/package.sh --target maa-x64-windows --with-maacore <MaaCore 路径>
```

`--with-maacore` 可选；不提供时仅启用 ONNX 会话加速，OCR 仍走 FastDeploy。默认优先读取 `openvino-pack/ci/` 中下载的运行时，其次读取 `runtime/<target>`；也可用 `--runtime <目录>` 显式指定。缺少必需运行库时打包会直接失败。

## 安装 / 回滚

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1 -MaaDir "C:\path\to\MAA"
powershell -ExecutionPolicy Bypass -File install.ps1 -MaaDir "C:\path\to\MAA" -Rollback
```

安装前会备份被覆盖的 DLL。请确保加速包与 MAA 版本匹配。

## 使用与限制

- 后端选项：`OpenVINO CPU` / `OpenVINO NPU` / `OpenVINO Hybrid`
- Hybrid：OCR 使用 OpenVINO CPU，ONNX 会话使用 NPU；**NPU 仅加速 ONNX 会话，并非全链路 NPU**
- 实验性：需要可用的 Intel NPU 驱动，部分模型/驱动可能不兼容，失败会自动回退 CPU
- 仅分发 Release 运行时；不支持 Debug 配置的原生 OpenVINO OCR
- 不包含 Intel GPU 插件与多语言前端，以控制体积

## 从 CI 下载产物

```bash
GH_TOKEN=xxx python fetch_ci_artifact.py <run_id> --target x64-windows
```

产物解包到 `openvino-pack/ci/`，再使用 `package.sh` 打包并 `install.ps1` 安装。
