# VibeVoice macOS 部署指南 (Mac mini M4 Pro)

## 🖥️ Mac mini M4 Pro 基础版规格分析

**标准配置**:
- CPU: 10 核 (8P + 2E)
- GPU: 10 核
- 内存: 16GB 统一内存
- 存储: 256GB/512GB SSD

**关键考虑**:
- ⚠️ 存储较紧张 - 需要优化模型部署策略
- ✅ 统一内存设计 - GPU/CPU 共享内存，推理高效
- ✅ MPS 支持 - 充分利用 Apple Silicon GPU
- ⚠️ 多个大模型同时加载可能出现内存压力

## 系统要求

- macOS (已确认: Mac mini M4 Pro)
- Python >= 3.9
- **存储**: 根据部署方案选择 (详见下文)
- **内存**: 16GB+ (基础版满足，多任务时需谨慎)

## 📊 存储方案选择

### 方案 A: 最小化部署 (推荐 256GB SSD)
仅使用 Realtime TTS，存储需求最小：
- VibeVoice-Realtime-0.5B: ~1GB
- 项目代码 + 依赖: ~2GB
- **总计**: ~5GB
- **剩余空间**: 250GB+ 可用

### 方案 B: 标准部署 (推荐 512GB SSD)
同时支持 ASR 和 Realtime TTS：
- VibeVoice-ASR: ~14GB
- VibeVoice-Realtime-0.5B: ~1GB
- Qwen2.5-7B: ~14GB
- 项目 + 依赖: ~2GB
- **总计**: ~35GB
- **剩余空间**: 470GB+ 可用

### 方案 C: 完整部署 (需要外置存储或扩展)
包含所有可选模型，需要外置 SSD：
- 所有模型: ~45GB
- 项目 + 依赖: ~3GB
- **总计**: ~50GB+
- **建议**: 使用外置 Thunderbolt SSD

> **注意**: 如果 SSD 容量紧张 (< 100GB 剩余)，建议使用外置存储或量化模型

## 部署步骤

### 1. 检查存储空间
```bash
# 查看 SSD 剩余空间
df -h / | awk 'NR==2 {print "总容量:", $2, "已用:", $3, "可用:", $4}'

# 建议 50GB+ 可用空间用于模型
# 如果不足，考虑使用外置 SSD 或选择最小化方案
```

### 2. 安装 uv（推荐）
```bash
# 使用 Homebrew 安装 uv
brew install uv

# 验证安装
uv --version
```

### 3. 进入项目目录
```bash
cd /Users/leonyu/VibeVoice
```

### 4. 创建虚拟环境并安装依赖
```bash
# 使用 uv 创建虚拟环境
uv venv venv

# 激活虚拟环境
source venv/bin/activate

# 使用 uv 安装项目依赖
uv pip install -e .
```

### 5. 验证 PyTorch 和 MPS
```bash
python << 'EOF'
import torch
print(f"✓ PyTorch 版本: {torch.__version__}")
print(f"✓ MPS 可用: {torch.backends.mps.is_available()}")
print(f"✓ Metal 支持: {torch.backends.mps.is_available()}")

# 测试 MPS 计算
x = torch.randn(100, 100, device='mps')
y = torch.randn(100, 100, device='mps')
z = torch.mm(x, y)
print(f"✓ MPS 计算测试通过")
EOF
```

### 6. 根据需求选择下载模型

**方案 A: 仅 Realtime TTS**
```bash
bash download_models.sh
# 选择选项 2: VibeVoice-Realtime-0.5B
```

**方案 B: ASR + Realtime TTS**
```bash
bash download_models.sh
# 依次选择:
# 1) VibeVoice-ASR
# 2) VibeVoice-Realtime-0.5B
# 3) Qwen2.5-7B
```

**方案 C: 完整部署**
```bash
bash download_models.sh
# 选择选项 5: 全部下载
```

### 7. 内存优化配置

为了充分利用 M4 Pro 的 16GB 统一内存，可以设置以下环境变量：

```bash
# 启用 PyTorch 优化
export PYTORCH_ENABLE_MPS_FALLBACK=1
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0

# 优化推理内存占用
export OMP_NUM_THREADS=8  # 根据 P 核数调整

# 可选: 启用量化推理 (节省 50% 内存)
export TORCH_DTYPE=bfloat16
```

### 8. 测试部署

#### 测试 Realtime TTS (轻量级)
```bash
cd demo
python vibevoice_realtime_demo.py --text "Hello, this is a test."
```

#### 测试 ASR (重量级)
```bash
cd demo
# 需要音频文件
python vibevoice_asr_inference_from_file.py --audio_path path/to/audio.wav
```

#### 运行 Web 服务
```bash
cd demo/web
python app.py
# 访问 http://localhost:7860
```

## ⚙️ M4 Pro 性能优化建议

### 1. 批量推理时的内存管理
```python
import torch
torch.mps.empty_cache()  # 在推理前清空缓存

# 分批处理大型输入，避免内存溢出
batch_size = 2  # 而非 8-16
```

### 2. 启用量化推理 (节省 50% 内存)
```python
from vibevoice.modular.modeling_vibevoice_asr import VibeVoiceASR
import torch

model = VibeVoiceASR.from_pretrained(
    "microsoft/VibeVoice-ASR",
    torch_dtype=torch.float16,  # 或 torch.bfloat16
    device_map="auto"
)
```

### 3. 使用外置 SSD 存储模型
```bash
# 在外置 SSD 上创建模型目录
export HF_HOME=/Volumes/External-SSD/.cache/huggingface

# 下载模型到外置存储
bash download_models.sh
```

## 常见问题

### Q: 256GB 存储不够，怎么办？
A: 
1. **方案 A**: 仅使用 Realtime-0.5B (1GB)
2. **外置存储**: 使用 Thunderbolt SSD 存储模型
3. **量化模型**: 下载 INT8 量化版本 (大小减半)
4. **删除不用的模型**: `rm -rf ~/.cache/huggingface/models/`

### Q: 多模型同时运行内存不足？
A:
```bash
# 顺序加载模型而非并行
# 或调整 batch size:
export CUDA_VISIBLE_DEVICES=""  # 仅使用 CPU (较慢)

# 或限制 GPU 内存
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb=512
```

### Q: 部署时出现 torch 相关错误？
A: Mac M4 上应该使用支持 MPS（Metal Performance Shaders）的 PyTorch。如果需要重新安装：
```bash
uv pip install --upgrade torch torchvision torchaudio
```

### Q: MPS 不可用？
A:
```bash
# 检查 Python 架构
python -c "import platform; print(platform.processor())"
# 应该输出: arm 或 Apple silicon

# 确保使用 arm64 版本的 Python (非 x86_64 via Rosetta)
# 重新安装 Python:
brew install python@3.11  # arm64 原生版本
```

### Q: 如何升级依赖？
A: 
```bash
uv pip install --upgrade -e .
```

### Q: 如何卸载虚拟环境？
A:
```bash
rm -rf venv/
unset HF_HOME  # 如果设置过
```

## 文件结构说明
- `vibevoice/` - 主要源代码
  - `modular/` - 模型定义
  - `processor/` - 数据处理器
  - `schedule/` - 调度和采样器
- `demo/` - 演示脚本和 Web 应用
- `vllm_plugin/` - vLLM 集成（可选）
- `finetuning-asr/` - ASR 微调代码

## 下一步

根据使用场景选择：
1. **仅推理** - 按上述步骤完成即可
2. **微调 ASR** - 参考 `finetuning-asr/README.md` (需要 40GB+ 存储)
3. **集成 vLLM** - 参考 `docs/vibevoice-vllm-asr.md` (需要 NVIDIA GPU)
4. **生产部署** - 建议使用外置 SSD 或云平台

## 参考资源

- [MODEL_WEIGHTS.md](MODEL_WEIGHTS.md) - 详细模型信息
- [README.md](README.md) - 项目概览
- [docs/vibevoice-asr.md](docs/vibevoice-asr.md) - ASR 文档
- [docs/vibevoice-realtime-0.5b.md](docs/vibevoice-realtime-0.5b.md) - Realtime TTS 文档


