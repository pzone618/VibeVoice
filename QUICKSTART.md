# VibeVoice 快速启动指南

本文档提供了最快速的方式启动 VibeVoice 工程。

## 🚀 快速启动 (5 分钟)

### 1️⃣ 第一次部署 (仅需一次)

```bash
# 进入项目目录
cd /Users/leonyu/VibeVoice

# 运行自动部署脚本 (推荐)
bash deploy_macos.sh

# 或手动部署
source venv/bin/activate
uv pip install -e .
```

**预期输出**:
```
✓ Python 版本: 3.13
✓ uv 已安装: uv 0.9.27
✓ 虚拟环境创建完成
✓ 依赖安装完成
✓ vibevoice 已安装
✓ torch 版本: 2.10.0
✓ MPS 可用: True
```

---

### 2️⃣ 激活虚拟环境 (每次使用都需要)

```bash
cd /Users/leonyu/VibeVoice
source venv/bin/activate
```

**验证激活成功**:
```bash
# 应该显示 (venv) 前缀
which python  # 应该指向 ./venv/bin/python
python --version
```

---

### 3️⃣ 下载模型权重 (仅需一次)

根据你的 SSD 容量选择:

#### 选项 A: 最小化 (256GB SSD 推荐)
```bash
# 仅下载 Realtime TTS (1GB)
bash download_models.sh
# 菜单中选择: 2
```

#### 选项 B: 标准配置 (512GB SSD 推荐)
```bash
# 下载 ASR + Realtime + Qwen2.5
bash download_models.sh
# 菜单中依次选择: 1 2 3
```

#### 选项 C: 完整配置 (需要外置 SSD)
```bash
bash download_models.sh
# 菜单中选择: 5
```

---

### 4️⃣ 启动应用

#### 选项 1: Web 界面 (推荐)
```bash
# 最简单，支持 ASR + TTS
cd demo/web
python app.py

# 打开浏览器访问
# http://localhost:7860
```

#### 选项 2: 命令行 TTS
```bash
# 生成语音
cd demo
python vibevoice_realtime_demo.py --text "Hello, how are you?"

# 输出会保存为 WAV 文件
```

#### 选项 3: 命令行 ASR
```bash
# 转录音频
cd demo
python vibevoice_asr_inference_from_file.py --audio_path your_audio.wav

# 输出转录结果和说话人信息
```

---

## 📊 选择启动方案

| 方案 | 用途 | 命令 | 所需模型 | 启动时间 |
|------|------|------|--------|--------|
| **Web UI** | 易用演示 | `cd demo/web && python app.py` | 可选 | ~5秒 |
| **Realtime TTS** | 快速 TTS | `cd demo && python vibevoice_realtime_demo.py --text "..."` | Realtime-0.5B | ~3秒 |
| **ASR** | 语音识别 | `cd demo && python vibevoice_asr_inference_from_file.py --audio_path ...` | ASR + Qwen | ~30秒 |
| **自定义脚本** | 开发集成 | Python 脚本调用 | 按需 | 取决于脚本 |

---

## 📁 项目结构速览

```
VibeVoice/
├── venv/                          # 虚拟环境 (首次部署后自动生成)
├── models/                        # 模型权重 (首次下载后自动生成)
│   ├── VibeVoice-ASR/
│   ├── VibeVoice-Realtime-0.5B/
│   ├── Qwen2.5-7B/
│   └── VibeVoice-1.5B/ (可选)
├── demo/                          # 演示脚本
│   ├── web/
│   │   ├── app.py                 # Web 服务入口
│   │   └── index.html
│   ├── vibevoice_asr_inference_from_file.py         # ASR 推理
│   ├── vibevoice_realtime_demo.py                   # TTS 演示
│   └── download_experimental_voices.sh
├── vibevoice/                     # 核心代码
│   ├── modular/                   # 模型定义
│   ├── processor/                 # 处理器
│   └── schedule/
├── docs/                          # 文档
├── README.md                      # 项目说明
├── DEPLOY_MACOS.md                # macOS 部署指南
├── MODEL_WEIGHTS.md               # 模型下载指南
├── M4_PRO_OPTIMIZATION.md         # M4 Pro 优化指南
├── deploy_macos.sh                # 自动部署脚本
└── download_models.sh             # 模型下载脚本
```

---

## ❓ 常见启动问题

### Q: 激活虚拟环境后 Python 找不到？
```bash
# 检查虚拟环境路径
which python
# 应该输出: /Users/leonyu/VibeVoice/venv/bin/python

# 如果不对，重新激活
source venv/bin/activate
```

### Q: 第一次运行很慢？
```bash
# 原因: 首次加载大模型，需要从 HF 下载
# 建议提前下载:
bash download_models.sh

# 之后运行会快很多
```

### Q: 模型加载报错？
```bash
# 1. 检查虚拟环境是否激活
source venv/bin/activate

# 2. 检查模型是否下载
ls -la models/

# 3. 验证 torch MPS
python -c "import torch; print(torch.backends.mps.is_available())"

# 4. 检查 HF 缓存
ls -la ~/.cache/huggingface/hub/
```

### Q: Web 服务启动失败？
```bash
# 1. 检查端口是否被占用
lsof -i :7860

# 2. 指定其他端口
cd demo/web
python app.py --server_name 0.0.0.0 --server_port 8000

# 3. 访问 http://localhost:8000
```

### Q: 内存不足？
```bash
# 查看系统内存占用
top -b -n 1 | grep Memory

# 启用量化推理 (减少 50% 内存)
# 在脚本中添加:
import torch
model = model.to(torch.float16)

# 或仅使用 Realtime-0.5B (更轻量)
bash download_models.sh  # 选择 2
```

---

## 🔄 日常使用流程

### 每次使用前

```bash
cd /Users/leonyu/VibeVoice
source venv/bin/activate
```

### 运行 Web UI

```bash
cd demo/web
python app.py
# 浏览器打开 http://localhost:7860
```

### 停止服务

```bash
# 在终端中按 Ctrl+C 停止服务
^C

# 退出虚拟环境
deactivate
```

---

## 🛠️ 环境变量配置 (可选)

为了优化性能，可以在 `~/.zprofile` 或 `~/.bash_profile` 中添加:

```bash
# 优化 PyTorch MPS
export PYTORCH_ENABLE_MPS_FALLBACK=1
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0

# 优化线程
export OMP_NUM_THREADS=8

# 使用外置存储存放模型 (可选)
export HF_HOME=/Volumes/ExternalSSD/.cache/huggingface
```

然后重启终端使配置生效:

```bash
source ~/.zprofile
```

---

## 🚀 进阶启动方式

### 后台运行 Web 服务

```bash
cd /Users/leonyu/VibeVoice
source venv/bin/activate
nohup python demo/web/app.py > web_server.log 2>&1 &

# 查看日志
tail -f web_server.log

# 停止服务
kill %1
```

### 创建快捷启动脚本

创建文件 `~/start_vibevoice.sh`:

```bash
#!/bin/bash
cd /Users/leonyu/VibeVoice
source venv/bin/activate
cd demo/web
python app.py
```

然后:

```bash
chmod +x ~/start_vibevoice.sh
~/start_vibevoice.sh
```

### 与其他应用集成

```python
# 在你的应用中导入和使用
import sys
sys.path.insert(0, '/Users/leonyu/VibeVoice')

from vibevoice.modular.modeling_vibevoice_streaming import VibeVoiceStreaming

model = VibeVoiceStreaming.from_pretrained('microsoft/VibeVoice-Realtime-0.5B')
audio = model.generate("Your text here")
```

---

## 📚 获取帮助

- **部署问题**: 查看 [DEPLOY_MACOS.md](DEPLOY_MACOS.md)
- **模型下载**: 查看 [MODEL_WEIGHTS.md](MODEL_WEIGHTS.md)
- **M4 Pro 优化**: 查看 [M4_PRO_OPTIMIZATION.md](M4_PRO_OPTIMIZATION.md)
- **ASR 详细文档**: 查看 [docs/vibevoice-asr.md](docs/vibevoice-asr.md)
- **Realtime TTS 详细文档**: 查看 [docs/vibevoice-realtime-0.5b.md](docs/vibevoice-realtime-0.5b.md)

---

## ✅ 启动检查清单

启动前逐项检查:

- [ ] 进入项目目录: `cd /Users/leonyu/VibeVoice`
- [ ] 虚拟环境已激活: `source venv/bin/activate`
- [ ] (第一次) 依赖已安装: `python -c "import vibevoice"`
- [ ] (第一次) 模型已下载: `ls -la models/`
- [ ] MPS 可用: `python -c "import torch; print(torch.backends.mps.is_available())"`
- [ ] 选择启动方式:
  - [ ] Web UI: `cd demo/web && python app.py`
  - [ ] 命令行 TTS: `cd demo && python vibevoice_realtime_demo.py --text "..."`
  - [ ] 命令行 ASR: `cd demo && python vibevoice_asr_inference_from_file.py --audio_path ...`

---

## 🎯 下一步

完成启动后，你可以:

1. **尝试 Web 界面** - 最直观的方式
2. **阅读 ASR 文档** - 了解语音识别功能
3. **阅读 Realtime 文档** - 了解 TTS 功能
4. **研究 demo 脚本** - 学习如何集成到你的应用
5. **参考 M4 Pro 优化** - 了解性能优化技巧
