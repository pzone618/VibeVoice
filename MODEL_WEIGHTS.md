# VibeVoice 模型权重下载指南

本文档列出了 VibeVoice 项目所有需要的模型权重及下载方式。

## 📦 模型列表概览

| 模型名称 | 模型 ID | 大小 | 用途 | 下载链接 |
|---------|--------|------|------|--------|
| VibeVoice-ASR | `microsoft/VibeVoice-ASR` | ~7B | 语音识别 | [HF](https://huggingface.co/microsoft/VibeVoice-ASR) |
| VibeVoice-Realtime-0.5B | `microsoft/VibeVoice-Realtime-0.5B` | ~0.5B | 实时 TTS | [HF](https://huggingface.co/microsoft/VibeVoice-Realtime-0.5B) |
| VibeVoice-1.5B | `microsoft/VibeVoice-1.5B` | ~1.5B | 长文本 TTS | [HF](https://huggingface.co/microsoft/VibeVoice-1.5B) |
| Qwen2.5-7B | `Qwen/Qwen2.5-7B` | ~7B | 依赖 LLM | [HF](https://huggingface.co/Qwen/Qwen2.5-7B) |

## 🚀 快速下载方式

### 方式 1: 使用 Python (推荐)

激活虚拟环境后运行：

```bash
source venv/bin/activate

# 下载 VibeVoice-ASR (ASR 必需)
python -c "
from huggingface_hub import snapshot_download
model_path = snapshot_download(repo_id='microsoft/VibeVoice-ASR', local_dir='./models/VibeVoice-ASR')
print(f'✓ 模型已下载至: {model_path}')
"

# 下载 VibeVoice-Realtime-0.5B (Realtime TTS 必需)
python -c "
from huggingface_hub import snapshot_download
model_path = snapshot_download(repo_id='microsoft/VibeVoice-Realtime-0.5B', local_dir='./models/VibeVoice-Realtime-0.5B')
print(f'✓ 模型已下载至: {model_path}')
"

# 下载 Qwen2.5-7B (ASR 依赖)
python -c "
from huggingface_hub import snapshot_download
model_path = snapshot_download(repo_id='Qwen/Qwen2.5-7B', local_dir='./models/Qwen2.5-7B')
print(f'✓ 模型已下载至: {model_path}')
"

# 可选: 下载 VibeVoice-1.5B (长文本 TTS)
python -c "
from huggingface_hub import snapshot_download
model_path = snapshot_download(repo_id='microsoft/VibeVoice-1.5B', local_dir='./models/VibeVoice-1.5B')
print(f'✓ 模型已下载至: {model_path}')
"
```

### 方式 2: 使用 Git LFS

```bash
# 安装 Git LFS (macOS)
brew install git-lfs
git lfs install

# 克隆模型仓库
git clone https://huggingface.co/microsoft/VibeVoice-ASR ./models/VibeVoice-ASR
git clone https://huggingface.co/microsoft/VibeVoice-Realtime-0.5B ./models/VibeVoice-Realtime-0.5B
git clone https://huggingface.co/Qwen/Qwen2.5-7B ./models/Qwen2.5-7B
```

### 方式 3: 手动下载 (Web 界面)

1. 访问 [https://huggingface.co/microsoft/VibeVoice-ASR](https://huggingface.co/microsoft/VibeVoice-ASR)
2. 点击 "Files and versions" 标签
3. 单击 "Download" 下载所有文件
4. 解压到 `./models/VibeVoice-ASR` 目录

## 📋 详细模型说明

### 1. VibeVoice-ASR (必需)

**用途**: 语音识别 (Speech-to-Text)

**参数**: 7B  
**大小**: ~14GB (fp16) / ~7GB (int8)  
**存储需求**: 20GB

**下载**:
```bash
python -c "from huggingface_hub import snapshot_download; snapshot_download('microsoft/VibeVoice-ASR')"
```

**使用**:
```python
from vibevoice.modular.modeling_vibevoice_asr import VibeVoiceASRForConditionalGeneration
from vibevoice.processor.vibevoice_asr_processor import VibeVoiceASRProcessor

model = VibeVoiceASRForConditionalGeneration.from_pretrained("microsoft/VibeVoice-ASR")
processor = VibeVoiceASRProcessor.from_pretrained("microsoft/VibeVoice-ASR")
```

**功能**:
- 支持 50+ 语言
- 60 分钟长音频处理
- 说话人识别和时间戳
- 自定义热词

---

### 2. VibeVoice-Realtime-0.5B (必需)

**用途**: 实时文本转语音 (Real-time TTS)

**参数**: 0.5B  
**大小**: ~1GB  
**存储需求**: 3GB

**下载**:
```bash
python -c "from huggingface_hub import snapshot_download; snapshot_download('microsoft/VibeVoice-Realtime-0.5B')"
```

**使用**:
```python
from vibevoice.modular.modeling_vibevoice_streaming import VibeVoiceStreaming

model = VibeVoiceStreaming.from_pretrained("microsoft/VibeVoice-Realtime-0.5B")
audio = model.generate(text="Hello world")
```

**功能**:
- 实时流式处理
- 首字延迟 ~300ms
- 支持长达 10 分钟音频生成
- 多语言支持 (EN, DE, FR, IT, JP, KR, NL, PL, PT, ES)

**可选实验语音**: 
```bash
cd demo
bash download_experimental_voices.sh  # 下载额外的语音样本
```

---

### 3. Qwen2.5-7B (依赖)

**用途**: 作为 VibeVoice ASR 的 LLM 主干

**参数**: 7B  
**大小**: ~14GB (fp16) / ~7GB (int8)  
**存储需求**: 20GB

**下载**:
```bash
python -c "from huggingface_hub import snapshot_download; snapshot_download('Qwen/Qwen2.5-7B')"
```

**注意**: VibeVoiceASRProcessor 会自动尝试加载此模型，如果网络不稳定可提前下载。

---

### 4. VibeVoice-1.5B (可选)

**用途**: 长文本多说话人文本转语音 (TTS)

**参数**: 1.5B  
**大小**: ~3GB  
**存储需求**: 8GB

**下载**:
```bash
python -c "from huggingface_hub import snapshot_download; snapshot_download('microsoft/VibeVoice-1.5B')"
```

**使用**:
```python
from vibevoice.modular.modeling_vibevoice import VibeVoiceTTS

model = VibeVoiceTTS.from_pretrained("microsoft/VibeVoice-1.5B")
```

**功能**:
- 支持 90 分钟长音频生成
- 最多 4 个说话人
- 支持中英文和多语言

---

## 🗂️ 目录结构

下载完成后，建议的目录结构：

```
VibeVoice/
├── models/
│   ├── VibeVoice-ASR/           # ASR 模型权重
│   │   ├── config.json
│   │   ├── pytorch_model.bin
│   │   ├── tokenizer.json
│   │   └── ...
│   ├── VibeVoice-Realtime-0.5B/ # Realtime TTS 模型权重
│   │   ├── config.json
│   │   ├── pytorch_model.bin
│   │   └── ...
│   ├── Qwen2.5-7B/              # 依赖 LLM
│   │   ├── config.json
│   │   ├── pytorch_model.bin
│   │   └── ...
│   └── VibeVoice-1.5B/          # 可选: TTS 模型权重
│       ├── config.json
│       ├── pytorch_model.bin
│       └── ...
├── venv/
├── demo/
├── vibevoice/
└── ...
```

## 🔑 HuggingFace 认证

如果模型为私有或需要认证，安装前认证：

```bash
# 获取 token: https://huggingface.co/settings/tokens

huggingface-cli login
# 或
python -c "from huggingface_hub import login; login()"
```

## 📊 存储空间需求

| 配置 | 最小需求 | 推荐配置 |
|------|---------|--------|
| ASR 仅推理 | 25GB | 30GB |
| Realtime TTS 仅推理 | 5GB | 10GB |
| 两者都用 | 35GB | 50GB |
| 包括 TTS-1.5B | 45GB | 65GB |
| 完整配置 | 60GB | 80GB |

## 🔍 验证下载

下载完成后验证完整性：

```bash
python -c "
import torch
from vibevoice.modular.modeling_vibevoice_asr import VibeVoiceASRForConditionalGeneration

try:
    model = VibeVoiceASRForConditionalGeneration.from_pretrained('./models/VibeVoice-ASR')
    print('✓ VibeVoice-ASR 模型加载成功')
except Exception as e:
    print(f'✗ VibeVoice-ASR 加载失败: {e}')
"
```

## ⚡ 性能优化

### 量化模型 (节省显存)

```bash
# 下载 INT8 量化版本 (如果可用)
python -c "
from huggingface_hub import snapshot_download
snapshot_download('microsoft/VibeVoice-ASR-int8')
"
```

### 使用 vLLM 加速推理

```bash
# 参考: docs/vibevoice-vllm-asr.md
python vllm_plugin/scripts/start_server.py --model microsoft/VibeVoice-ASR
```

## 🐛 常见问题

**Q: 下载很慢？**  
A: 
- 使用代理或 VPN
- 尝试国内镜像: https://hf-mirror.com
- 使用 `--resume-download` 断点续传

**Q: 显存不足？**  
A:
- 使用量化模型 (INT8/INT4)
- 减小 batch size
- 使用 CPU 推理 (较慢)

**Q: 如何离线使用？**  
A:
```python
# 使用本地路径
model = VibeVoiceASR.from_pretrained("./models/VibeVoice-ASR")
```

**Q: 模型需要联网吗？**  
A: 第一次加载需要下载，之后可离线使用 (设置 `offload_folder`)

## 📚 相关文档

- [VibeVoice-ASR 文档](docs/vibevoice-asr.md)
- [VibeVoice-Realtime 文档](docs/vibevoice-realtime-0.5b.md)
- [vLLM 集成指南](docs/vibevoice-vllm-asr.md)
- [ASR 微调指南](finetuning-asr/README.md)
