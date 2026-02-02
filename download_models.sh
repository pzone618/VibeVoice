#!/bin/bash

# VibeVoice 模型权重自动下载脚本
# 支持断点续传和选择性下载

set -e

echo "🤖 VibeVoice 模型权重下载工具"
echo "================================"
echo ""

# 配置
MODELS_DIR="${1:-.}/models"
CACHE_DIR="${HF_HOME:-.cache/huggingface}"

# 创建模型目录
mkdir -p "$MODELS_DIR"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函数: 下载模型
download_model() {
    local model_id=$1
    local output_dir=$2
    local description=$3
    
    echo -e "${BLUE}📥 开始下载: $description${NC}"
    echo "   Model ID: $model_id"
    echo "   Output:   $output_dir"
    echo ""
    
    python3 << EOF
from huggingface_hub import snapshot_download
import os

try:
    print("正在连接 HuggingFace 仓库...")
    model_path = snapshot_download(
        repo_id='$model_id',
        local_dir='$output_dir',
        resume_download=True,
        force_download=False
    )
    print(f"✓ 下载完成: {model_path}")
    print(f"✓ 总大小: {sum(os.path.getsize(os.path.join(dirpath, filename)) for dirpath, dirnames, filenames in os.walk(model_path) for filename in filenames) / (1024**3):.2f} GB")
except Exception as e:
    print(f"✗ 下载失败: {e}")
    exit(1)
EOF
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ $description 下载成功${NC}"
    else
        echo -e "${RED}✗ $description 下载失败${NC}"
        return 1
    fi
    echo ""
}

# 菜单
show_menu() {
    echo -e "${YELLOW}选择要下载的模型:${NC}"
    echo ""
    echo "1) VibeVoice-ASR (必需) - 7B 语音识别模型"
    echo "2) VibeVoice-Realtime-0.5B (必需) - 0.5B 实时 TTS 模型"
    echo "3) Qwen2.5-7B (依赖) - 7B 基础 LLM 模型"
    echo "4) VibeVoice-1.5B (可选) - 1.5B TTS 模型"
    echo "5) 全部下载"
    echo "6) 退出"
    echo ""
}

# 主程序
main() {
    while true; do
        show_menu
        read -p "请选择 (1-6): " choice
        
        case $choice in
            1)
                download_model "microsoft/VibeVoice-ASR" "$MODELS_DIR/VibeVoice-ASR" "VibeVoice-ASR"
                ;;
            2)
                download_model "microsoft/VibeVoice-Realtime-0.5B" "$MODELS_DIR/VibeVoice-Realtime-0.5B" "VibeVoice-Realtime-0.5B"
                ;;
            3)
                download_model "Qwen/Qwen2.5-7B" "$MODELS_DIR/Qwen2.5-7B" "Qwen2.5-7B"
                ;;
            4)
                download_model "microsoft/VibeVoice-1.5B" "$MODELS_DIR/VibeVoice-1.5B" "VibeVoice-1.5B"
                ;;
            5)
                echo -e "${YELLOW}开始全量下载所有模型...${NC}"
                echo ""
                
                download_model "microsoft/VibeVoice-ASR" "$MODELS_DIR/VibeVoice-ASR" "VibeVoice-ASR" || true
                download_model "microsoft/VibeVoice-Realtime-0.5B" "$MODELS_DIR/VibeVoice-Realtime-0.5B" "VibeVoice-Realtime-0.5B" || true
                download_model "Qwen/Qwen2.5-7B" "$MODELS_DIR/Qwen2.5-7B" "Qwen2.5-7B" || true
                download_model "microsoft/VibeVoice-1.5B" "$MODELS_DIR/VibeVoice-1.5B" "VibeVoice-1.5B" || true
                
                echo -e "${GREEN}全部下载完成！${NC}"
                ;;
            6)
                echo "退出"
                exit 0
                ;;
            *)
                echo -e "${RED}无效选择${NC}"
                ;;
        esac
        
        echo ""
        read -p "按 Enter 继续..."
        clear
    done
}

# 检查依赖
check_dependencies() {
    echo "检查依赖..."
    
    if ! command -v python3 &> /dev/null; then
        echo -e "${RED}✗ Python 3 未安装${NC}"
        exit 1
    fi
    
    python3 -c "from huggingface_hub import snapshot_download" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}⚠️  huggingface_hub 未安装，正在安装...${NC}"
        pip3 install huggingface-hub
    fi
    
    echo -e "${GREEN}✓ 依赖检查完成${NC}"
    echo ""
}

# 显示信息
show_info() {
    echo "下载目录: $MODELS_DIR"
    echo "缓存目录: $CACHE_DIR"
    echo ""
}

# 执行
check_dependencies
show_info
main
