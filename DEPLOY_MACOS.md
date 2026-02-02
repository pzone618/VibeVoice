# VibeVoice macOS 部署指南 (Mac mini M4 Pro)

## 系统要求
- macOS (已确认: Mac mini M4 Pro)
- Python >= 3.9
- 约 50GB+ 存储空间（用于模型权重）
- 16GB+ 内存推荐

## 部署步骤

### 1. 安装 uv（推荐）
```bash
# 使用 Homebrew 安装 uv
brew install uv

# 验证安装
uv --version
```

### 2. 进入项目目录
```bash
cd /Users/leonyu/VibeVoice
```

### 3. 创建虚拟环境并安装依赖
```bash
# 使用 uv 创建虚拟环境
uv venv venv

# 激活虚拟环境
source venv/bin/activate

# 使用 uv 安装项目依赖
uv pip install -e .
```

### 4. 验证安装
```bash
python -c "import vibevoice; print('VibeVoice 安装成功！')"
```

### 5. 下载模型权重（可选）
如果要使用 TTS 或 ASR 功能，需要下载对应模型：

#### 下载 ASR 模型
```bash
cd demo
python -c "from vibevoice.modular.modeling_vibevoice_asr import VibeVoiceASR; model = VibeVoiceASR.from_pretrained('microsoft/VibeVoice-ASR')"
```

#### 下载 Realtime TTS 模型
```bash
python -c "from vibevoice.modular.modeling_vibevoice_streaming import VibeVoiceStreaming; model = VibeVoiceStreaming.from_pretrained('microsoft/VibeVoice-Realtime-0.5B')"
```

#### 下载实验性语音（可选）
```bash
bash download_experimental_voices.sh
```

### 6. 测试部署

#### 运行 Web 服务
```bash
cd demo/web
python app.py
# 访问 http://localhost:7860
```

#### 运行 ASR 演示
```bash
cd demo
python vibevoice_asr_inference_from_file.py \
  --audio_path path/to/audio.wav \
  --model_id microsoft/VibeVoice-ASR
```

#### 运行 Realtime TTS 演示
```bash
cd demo
python vibevoice_realtime_demo.py \
  --text "Hello, this is a test."
```

## 常见问题

### Q: 部署时出现 torch 相关错误？
A: Mac M4 上应该使用支持 MPS（Metal Performance Shaders）的 PyTorch。如果需要重新安装：
```bash
uv pip install --upgrade torch torchvision torchaudio
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
```

## 虚拟环境激活/停用

激活虚拟环境（每次开新终端都需要）：
```bash
source venv/bin/activate
```

停用虚拟环境：
```bash
deactivate
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
2. **微调 ASR** - 参考 `finetuning-asr/README.md`
3. **集成 vLLM** - 参考 `docs/vibevoice-vllm-asr.md`
