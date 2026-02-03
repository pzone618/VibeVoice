# Mac mini M4 Pro 部署优化指南

本文档针对 Mac mini M4 Pro **基础版** (16GB 内存, 256GB/512GB SSD) 的特定优化策略。

## 🖥️ M4 Pro 基础版规格回顾

| 组件 | 规格 | 说明 |
|------|------|------|
| CPU | 10 核 (8P+2E) | P核用于高性能，E核用于高效 |
| GPU | 10 核 | 与 CPU 集成在同一芯片 |
| 内存 | 16GB 统一内存 | CPU/GPU 共享，无专属 VRAM |
| 存储 | 256GB/512GB SSD | 可能为限制因素 |
| 架构 | ARM64 | 原生 Apple Silicon |

## 📦 三层部署方案

### Level 1: 轻量级 (推荐 256GB SSD 用户)

**功能**: 实时文本转语音 + Web 演示

**模型**: 仅 VibeVoice-Realtime-0.5B
- 模型大小: ~1GB
- 推理内存: ~2GB
- 首字延迟: ~300ms
- 语言: EN, DE, FR, IT, JP, KR, NL, PL, PT, ES

**部署命令**:
```bash
# 下载
bash download_models.sh  # 选择 2

# 运行
cd demo/web && python app.py  # Web 界面
cd demo && python vibevoice_realtime_demo.py --text "Hello"  # 命令行
```

**存储计算**:
- 项目代码: ~200MB
- 虚拟环境 + 依赖: ~1.5GB
- 模型: ~1GB
- **总计**: ~2.7GB (100倍剩余空间)

**优点**:
- ✅ 占用存储最小
- ✅ 内存占用低 (16GB 充分)
- ✅ 启动快速
- ✅ 无需复杂配置

**缺点**:
- ❌ 仅支持 TTS
- ❌ 不支持语音识别

---

### Level 2: 标准配置 (推荐 512GB SSD 用户)

**功能**: 语音识别 + 实时 TTS + Web 演示

**模型**:
- VibeVoice-ASR (7B)
- VibeVoice-Realtime-0.5B (0.5B)
- Qwen2.5-7B (LLM 基础模型)

**部署命令**:
```bash
# 下载 (按顺序)
bash download_models.sh

# 运行 ASR
cd demo && python vibevoice_asr_inference_from_file.py --audio_path your_audio.wav

# 运行 TTS
cd demo && python vibevoice_realtime_demo.py --text "你的文本"

# Web 界面
cd demo/web && python app.py
```

**存储计算**:
- 项目代码: ~200MB
- 虚拟环境 + 依赖: ~1.5GB
- VibeVoice-ASR: ~14GB
- VibeVoice-Realtime-0.5B: ~1GB
- Qwen2.5-7B: ~14GB
- **总计**: ~30.7GB (剩余 ~480GB 可用)

**内存使用分析**:
- Realtime TTS 单独运行: ~2-3GB
- ASR 单独运行: ~8-10GB
- **注意**: 不能同时运行两个大模型

**优点**:
- ✅ 功能完整
- ✅ 16GB 内存可单独运行任意模型
- ✅ SSD 空间相对宽裕
- ✅ 支持 ASR 微调

**缺点**:
- ❌ 两个大模型无法并行
- ❌ 首次加载 ASR 较慢 (~30秒)
- ❌ 不支持 vLLM 加速 (需要 NVIDIA GPU)

**优化策略**:
```python
# 1. 顺序加载而非并行
# 先运行 ASR
python vibevoice_asr_inference_from_file.py --audio_path audio.wav
# 完成后，重启 Python 进程再运行 TTS
python vibevoice_realtime_demo.py --text "结果"

# 2. 启用低精度推理 (节省 50% 内存)
# 在 inference 脚本中添加:
import torch
model = model.to(torch.float16)  # 或 torch.bfloat16

# 3. 清理 GPU 缓存
import torch
torch.mps.empty_cache()
```

---

### Level 3: 完整配置 (需要外置存储)

**功能**: 全部功能 + ASR 长音频处理 + TTS 长文本 + 微调

**模型**:
- VibeVoice-ASR (7B)
- VibeVoice-Realtime-0.5B (0.5B)
- VibeVoice-1.5B (1.5B, 可选)
- Qwen2.5-7B (7B)

**存储需求**:
- 总计: ~50GB+

**部署建议**:
```bash
# 使用外置 Thunderbolt SSD (推荐 250GB+)
# 1. 连接外置 SSD
# 2. 格式化为 APFS 格式
# 3. 设置环境变量指向外置存储:

export HF_HOME=/Volumes/ExternalSSD/.cache/huggingface

# 4. 继续下载和运行
bash download_models.sh  # 选择 5: 全部下载
```

---

## ⚡ 性能优化技巧

### 1. 启用量化推理 (减少 50% 内存占用)

```python
from vibevoice.modular.modeling_vibevoice_asr import VibeVoiceASRForConditionalGeneration
import torch

# 方式 A: FP16 量化 (推荐)
model = VibeVoiceASRForConditionalGeneration.from_pretrained(
    "microsoft/VibeVoice-ASR",
    torch_dtype=torch.float16,
    device_map="auto"
)

# 方式 B: BFloat16 量化 (更好的数值稳定性)
model = VibeVoiceASRForConditionalGeneration.from_pretrained(
    "microsoft/VibeVoice-ASR",
    torch_dtype=torch.bfloat16,
    device_map="auto"
)
```

### 2. 优化 MPS (Metal Performance Shaders) 设置

```bash
# 启用 MPS 回退 (GPU 不支持的操作自动降到 CPU)
export PYTORCH_ENABLE_MPS_FALLBACK=1

# 禁用 MPS 内存分配优化 (少数情况下会提升性能)
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0

# 优化 OpenMP 线程数 (8P核)
export OMP_NUM_THREADS=8
export OPENBLAS_NUM_THREADS=8
export MKL_NUM_THREADS=8
```

### 3. 批处理优化

```python
# 错误: 大 batch size 导致内存溢出
batch_size = 32  # ❌ 太大

# 正确: 根据内存调整
batch_size = 2  # ✅ M4 Pro 推荐

# 处理多个输入文件
import torch
torch.mps.empty_cache()  # 每批处理前清空缓存

for audio_file in audio_files:
    # 处理单个文件
    result = model.process(audio_file)
    torch.mps.empty_cache()  # 处理后清空
```

### 4. 内存监控

```python
import torch
import psutil

def print_memory_usage():
    # GPU 内存
    if torch.backends.mps.is_available():
        # MPS 没有专用的内存监控，使用系统内存
        pass
    
    # 系统内存
    process = psutil.Process()
    mem = process.memory_info()
    print(f"内存占用: {mem.rss / 1024**3:.2f} GB")

# 推理前后监控
print("推理前:")
print_memory_usage()

result = model(inputs)

print("推理后:")
print_memory_usage()
```

### 5. 使用外置存储的模型

```bash
# 方式 1: 系统环境变量 (推荐)
export HF_HOME=/Volumes/ExternalSSD/.cache/huggingface
python your_script.py

# 方式 2: 在代码中设置
import os
os.environ['HF_HOME'] = '/Volumes/ExternalSSD/.cache/huggingface'
from vibevoice import ...

# 方式 3: 本地路径加载
model = Model.from_pretrained('/Volumes/ExternalSSD/models/VibeVoice-ASR')
```

---

## 🔍 常见问题解决

### Q: 运行 ASR 时报内存错误
A: 
```bash
# 方案 1: 启用量化
export TORCH_DTYPE=float16

# 方案 2: 限制 batch size
python your_script.py --batch_size 1

# 方案 3: 使用 CPU 推理 (很慢)
python your_script.py --device cpu
```

### Q: 模型加载速度很慢
A:
```bash
# 原因: 首次从 HF 下载
# 解决: 预先下载模型
bash download_models.sh

# 或检查网络连接
ping huggingface.co
```

### Q: SSD 快满了怎么办?
A:
```bash
# 清理 HF 缓存
rm -rf ~/.cache/huggingface/

# 或删除不需要的模型
rm -rf ~/.cache/huggingface/hub/models--microsoft--VibeVoice-1.5B

# 查看缓存占用
du -sh ~/.cache/huggingface/
```

### Q: 能同时运行 ASR 和 TTS 吗?
A: 
理论上可以，但需要：
- 16GB 内存可能不足 (ASR ~10GB + TTS ~3GB = 13GB+)
- 建议启用量化减少内存占用
- 或使用进程池限制并发

```python
# 使用进程池控制并发
from multiprocessing import Pool

def process_asr(audio_file):
    # ASR 处理
    pass

def process_tts(text):
    # TTS 处理
    pass

# 串行处理 (推荐)
with Pool(1) as p:
    p.apply(process_asr, (audio_file,))
    p.apply(process_tts, (text,))
```

---

## 📊 性能基准 (参考数据)

| 任务 | 模型 | 推理时间 | 内存占用 | MPS 加速 |
|------|------|--------|--------|---------|
| 1 分钟音频 ASR | VibeVoice-ASR | ~15-20s | 10GB | 3-5x vs CPU |
| 短文本 TTS | Realtime-0.5B | ~0.5s | 2GB | 2-3x vs CPU |
| 3 分钟长文本 TTS | Realtime-0.5B | ~3-5s | 2GB | 2-3x vs CPU |

*注: 实际性能取决于输入长度、精度设置、其他进程占用等因素*

---

## ✅ 推荐配置清单

### Level 1 (256GB SSD 最小化)
- [ ] 安装 uv 和 Python 3.11+
- [ ] 激活虚拟环境
- [ ] 安装 VibeVoice
- [ ] 下载 Realtime-0.5B 模型
- [ ] 测试 Web 服务
- [ ] 设置环境变量 (可选)

### Level 2 (512GB SSD 标准)
- [ ] 完成 Level 1 所有步骤
- [ ] 下载 ASR 和 Qwen2.5-7B 模型
- [ ] 配置量化推理 (可选)
- [ ] 测试 ASR 和 TTS
- [ ] 设置外置存储备份 (可选)

### Level 3 (外置 SSD 完整)
- [ ] 购买 Thunderbolt SSD (256GB+)
- [ ] 格式化并设置 HF_HOME
- [ ] 完成 Level 2 所有步骤
- [ ] 下载所有可选模型
- [ ] 配置微调环境

---

## 🔗 相关资源

- [DEPLOY_MACOS.md](DEPLOY_MACOS.md) - macOS 通用部署指南
- [MODEL_WEIGHTS.md](MODEL_WEIGHTS.md) - 模型下载详细说明
- [README.md](README.md) - 项目概览
- [finetuning-asr/README.md](finetuning-asr/README.md) - ASR 微调指南
