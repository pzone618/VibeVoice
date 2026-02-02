#!/bin/bash

# VibeVoice macOS 自动部署脚本
# 适用于 Mac mini M4 Pro 或其他 Apple Silicon Mac

set -e  # 遇到错误立即退出

echo "🚀 开始部署 VibeVoice..."
echo "================================"

# 检查 Python 版本
echo "检查 Python 版本..."
python_version=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo "✓ Python 版本: $python_version"

if ! command -v uv &> /dev/null; then
    echo "⚠️  uv 未安装，开始安装..."
    brew install uv
    echo "✓ uv 安装完成"
else
    echo "✓ uv 已安装: $(uv --version)"
fi

# 获取项目目录
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "✓ 项目目录: $PROJECT_DIR"

cd "$PROJECT_DIR"

# 检查虚拟环境是否存在
if [ -d "venv" ]; then
    echo "⚠️  虚拟环境已存在，跳过创建"
    read -p "是否要重新创建虚拟环境？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf venv
        uv venv venv
        echo "✓ 虚拟环境已重新创建"
    fi
else
    echo "创建虚拟环境..."
    uv venv venv
    echo "✓ 虚拟环境创建完成"
fi

# 激活虚拟环境
echo "激活虚拟环境..."
source venv/bin/activate
echo "✓ 虚拟环境已激活"

# 安装依赖
echo ""
echo "安装项目依赖（这可能需要几分钟）..."
uv pip install -e .
echo "✓ 依赖安装完成"

# 验证安装
echo ""
echo "验证安装..."
python -c "import vibevoice; import torch; print(f'✓ vibevoice 已安装'); print(f'✓ torch 已安装'); print(f'✓ torch 版本: {torch.__version__}'); print(f'✓ MPS 可用: {torch.backends.mps.is_available()}')"

echo ""
echo "================================"
echo "✅ 部署完成！"
echo ""
echo "后续使用说明："
echo "1. 激活虚拟环境: source venv/bin/activate"
echo "2. 运行 Web 服务: cd demo/web && python app.py"
echo "3. 运行 ASR 推理: cd demo && python vibevoice_asr_inference_from_file.py --audio_path <path>"
echo "4. 运行 TTS 演示: cd demo && python vibevoice_realtime_demo.py --text '<text>'"
echo ""
echo "更多信息请查看: DEPLOY_MACOS.md"
