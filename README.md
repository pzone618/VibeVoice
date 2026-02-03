<div align="center">

## 🎙️ VibeVoice: Open-Source Frontier Voice AI
[![Project Page](https://img.shields.io/badge/Project-Page-blue?logo=githubpages)](https://microsoft.github.io/VibeVoice)
[![Hugging Face](https://img.shields.io/badge/HuggingFace-Collection-orange?logo=huggingface)](https://huggingface.co/collections/microsoft/vibevoice-68a2ef24a875c44be47b034f)
[![TTS Report](https://img.shields.io/badge/TTS-Report-red?logo=arxiv)](https://arxiv.org/pdf/2508.19205)
[![ASR Report](https://img.shields.io/badge/ASR-Report-yellow?logo=arxiv)](https://arxiv.org/pdf/2601.18184)
[![Colab](https://img.shields.io/badge/StreamingTTS-Colab-green?logo=googlecolab)](https://colab.research.google.com/github/microsoft/VibeVoice/blob/main/demo/VibeVoice_colab.ipynb)
[![ASR Playground](https://img.shields.io/badge/ASR-Playground-6F42C1?logo=gradio)](https://aka.ms/vibevoice-asr)

</div>


<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="Figures/VibeVoice_logo_white.png">
  <img src="Figures/VibeVoice_logo.png" alt="VibeVoice Logo" width="300">
</picture>
</div>

<div align="left">

<h3>📰 News</h3>

<strong>2026-01-21: 📣 We open-sourced <a href="docs/vibevoice-asr.md"><strong>VibeVoice-ASR</strong></a>, a unified speech-to-text model designed to handle 60-minute long-form audio in a single pass, generating structured transcriptions containing Who (Speaker), When (Timestamps), and What (Content), with support for User-Customized Context. Try it in [Playground](https://aka.ms/vibevoice-asr)</strong>. 
- ⭐️ VibeVoice-ASR is natively multilingual, supporting over 50 languages — check the [supported languages](docs/vibevoice-asr.md#language-distribution) for details.
- 🔥 The VibeVoice-ASR [finetuning code](finetuning-asr/README.md) is now available!
- ⚡️ **vLLM inference** is now supported for faster inference; see [vllm-asr](docs/vibevoice-vllm-asr.md) for more details.
- 📑 [VibeVoice-ASR Technique Report](https://arxiv.org/pdf/2601.18184) is available.

2025-12-16: 📣 We added experimental speakers to <a href="docs/vibevoice-realtime-0.5b.md"><strong>VibeVoice‑Realtime‑0.5B</strong></a> for exploration, including multilingual voices in nine languages (DE, FR, IT, JP, KR, NL, PL, PT, ES) and 11 distinct English style voices. [Try it](docs/vibevoice-realtime-0.5b.md#optional-more-experimental-voices). More speaker types will be added over time.

2025-12-03: 📣 We open-sourced <a href="docs/vibevoice-realtime-0.5b.md"><strong>VibeVoice‑Realtime‑0.5B</strong></a>, a real‑time text‑to‑speech model that supports streaming text input and robust long-form speech generation. Try it on [Colab](https://colab.research.google.com/github/microsoft/VibeVoice/blob/main/demo/vibevoice_realtime_colab.ipynb).


2025-09-05: VibeVoice is an open-source research framework intended to advance collaboration in the speech synthesis community. After release, we discovered instances where the tool was used in ways inconsistent with the stated intent. Since responsible use of AI is one of Microsoft’s guiding principles, we have removed the VibeVoice-TTS code from this repository.


2025-08-25: 📣 We open-sourced <a href="docs/vibevoice-tts.md"><strong>VibeVoice-TTS</strong></a>, a long-form multi-speaker text-to-speech model that can synthesize speech up to 90 minutes long with up to 4 distinct speakers.

</div>

## Overview

VibeVoice is a **family of open-source frontier voice AI models** that includes both Text-to-Speech (TTS) and Automatic Speech Recognition (ASR) models. 

A core innovation of VibeVoice is its use of continuous speech tokenizers (Acoustic and Semantic) operating at an ultra-low frame rate of **7.5 Hz**. These tokenizers efficiently preserve audio fidelity while significantly boosting computational efficiency for processing long sequences. VibeVoice employs a [next-token diffusion](https://arxiv.org/abs/2412.08635) framework, leveraging a Large Language Model (LLM) to understand textual context and dialogue flow, and a diffusion head to generate high-fidelity acoustic details.

For more information, demos, and examples, please visit our [Project Page](https://microsoft.github.io/VibeVoice).


<div align="center">

| Model |   Weight | Quick Try |
|-------|--------------|---------|
| VibeVoice-ASR-7B | [HF Link](https://huggingface.co/microsoft/VibeVoice-ASR) |  [Playground](https://aka.ms/vibevoice-asr) |
| VibeVoice-TTS-1.5B | [HF Link](https://huggingface.co/microsoft/VibeVoice-1.5B) | Disabled |
| VibeVoice-Realtime-0.5B | [HF Link](https://huggingface.co/microsoft/VibeVoice-Realtime-0.5B) | [Colab](https://colab.research.google.com/github/microsoft/VibeVoice/blob/main/demo/vibevoice_realtime_colab.ipynb) |

</div>

## Models


### 1. 📖 [VibeVoice-ASR](docs/vibevoice-asr.md) - Long-form Speech Recognition

**VibeVoice-ASR** is a unified speech-to-text model designed to handle **60-minute long-form audio** in a single pass, generating structured transcriptions containing **Who (Speaker), When (Timestamps), and What (Content)**, with support for **Customized Hotwords**.

- **🕒 60-minute Single-Pass Processing**:
  Unlike conventional ASR models that slice audio into short chunks (often losing global context), VibeVoice ASR accepts up to **60 minutes** of continuous audio input within 64K token length. This ensures consistent speaker tracking and semantic coherence across the entire hour.

- **👤 Customized Hotwords**:
  Users can provide customized hotwords (e.g., specific names, technical terms, or background info) to guide the recognition process, significantly improving accuracy on domain-specific content.

- **📝 Rich Transcription (Who, When, What)**:
  The model jointly performs ASR, diarization, and timestamping, producing a structured output that indicates *who* said *what* and *when*.

[📖 Documentation](docs/vibevoice-asr.md) | [🤗 Hugging Face](https://huggingface.co/microsoft/VibeVoice-ASR) | [🎮 Playground](https://aka.ms/vibevoice-asr) | [🛠️ Finetuning](finetuning-asr/README.md) |  [📊 Paper](docs/VibeVoice-ASR-Report.pdf)


<p align="center">
  <img src="Figures/DER.jpg" alt="DER" width="50%"><br>
  <img src="Figures/cpWER.jpg" alt="cpWER" width="50%"><br>
  <img src="Figures/tcpWER.jpg" alt="tcpWER" width="50%">
</p>


<div align="center" id="vibevoice-asr">

https://github.com/user-attachments/assets/acde5602-dc17-4314-9e3b-c630bc84aefa

</div>
<br>

### 2. 🎙️ [VibeVoice-TTS](docs/vibevoice-tts.md) - Long-form Multi-speaker TTS

**Best for**: Long-form conversational audio, podcasts, multi-speaker dialogues

- **⏱️ 90-minute Long-form Generation**:
  Synthesizes conversational/single-speaker speech up to **90 minutes** in a single pass, maintaining speaker consistency and semantic coherence throughout.

- **👥 Multi-speaker Support**:
  Supports up to **4 distinct speakers** in a single conversation, with natural turn-taking and speaker consistency across long dialogues.

- **🎭 Expressive Speech**:
  Generates expressive, natural-sounding speech that captures conversational dynamics and emotional nuances.

- **🌐 Multi-lingual Support**:
  Supports English, Chinese and other languages.


[📖 Documentation](docs/vibevoice-tts.md) | [🤗 Hugging Face](https://huggingface.co/microsoft/VibeVoice-1.5B)  |  [📊 Paper](https://arxiv.org/pdf/2508.19205)


<div align="center">
  <img src="Figures/VibeVoice-TTS-results.jpg" alt="VibeVoice Results" width="80%">
</div>


**English**
<div align="center">

https://github.com/user-attachments/assets/0967027c-141e-4909-bec8-091558b1b784

</div>


**Chinese**
<div align="center">

https://github.com/user-attachments/assets/322280b7-3093-4c67-86e3-10be4746c88f

</div>

**Cross-Lingual**
<div align="center">

https://github.com/user-attachments/assets/838d8ad9-a201-4dde-bb45-8cd3f59ce722

</div>

**Spontaneous Singing**
<div align="center">

https://github.com/user-attachments/assets/6f27a8a5-0c60-4f57-87f3-7dea2e11c730

</div>


**Long Conversation with 4 people**
<div align="center">

https://github.com/user-attachments/assets/a357c4b6-9768-495c-a576-1618f6275727

</div>





<br>

### 3. ⚡ [VibeVoice-Streaming](docs/vibevoice-realtime-0.5b.md) - Real-time Streaming TTS

VibeVoice-Realtime is a **lightweight real‑time** text-to-speech model supporting **streaming text input** and **robust long-form speech generation**.

- Parameter size: 0.5B (deployment-friendly)
- Real-time TTS (~300 milliseconds first audible latency)
- Streaming text input
- Robust long-form speech generation (~10 minutes)

[📖 Documentation](docs/vibevoice-realtime-0.5b.md) | [🤗 Hugging Face](https://huggingface.co/microsoft/VibeVoice-Realtime-0.5B) | [🚀 Colab](https://colab.research.google.com/github/microsoft/VibeVoice/blob/main/demo/vibevoice_realtime_colab.ipynb)


<div align="center" id="generated-example-audio-vibevoice-realtime">

https://github.com/user-attachments/assets/0901d274-f6ae-46ef-a0fd-3c4fba4f76dc

</div>

<br>

## Quick Start

> **⚡ 最快启动**: 仅需 3 步，5 分钟内启动完整的 VibeVoice 工程！
> 
> 详见 [QUICKSTART.md](QUICKSTART.md) 快速启动指南。

### Installation

#### Prerequisites
- Python >= 3.9
- For macOS: Install [uv](https://docs.astral.sh/uv/getting-started/) for fast package management

#### Setup (macOS)
```bash
# Clone the repository
git clone https://github.com/microsoft/VibeVoice.git
cd VibeVoice

# For macOS (M1/M2/M4 or Intel), run the automated deployment script
bash deploy_macos.sh

# Or manual setup with uv
uv venv venv
source venv/bin/activate
uv pip install -e .
```

#### Setup (Linux/Windows)
```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install the package
pip install -e .
```

### Quick Examples

#### ASR (Speech-to-Text)
```python
from vibevoice.modular.modeling_vibevoice_asr import VibeVoiceASR
from vibevoice.processor.vibevoice_asr_processor import VibeVoiceASRProcessor

model_id = "microsoft/VibeVoice-ASR"
model = VibeVoiceASR.from_pretrained(model_id)
processor = VibeVoiceASRProcessor.from_pretrained(model_id)

# Process audio file
audio_path = "path/to/audio.wav"
inputs = processor(audio_path, return_tensors="pt")
outputs = model(**inputs)
result = processor.decode(outputs.sequences[0])
print(result)
```

#### Streaming TTS (Text-to-Speech)
```python
from vibevoice.modular.modeling_vibevoice_streaming import VibeVoiceStreaming

model_id = "microsoft/VibeVoice-Realtime-0.5B"
model = VibeVoiceStreaming.from_pretrained(model_id)

text = "Hello, this is a test."
audio = model.generate(text)
# Audio will be saved or returned based on model configuration
```

### Web Demo

Run the interactive Gradio web interface:
```bash
cd demo/web
python app.py
# Open http://localhost:7860 in your browser
```

### Model Weights

VibeVoice requires pretrained model weights from HuggingFace. You have multiple options to download them:

#### Automatic Download Script (Recommended)
```bash
# Interactive menu to select models
bash download_models.sh
```

#### Manual Download with Python
```bash
source venv/bin/activate

# Download VibeVoice-ASR (required for speech recognition)
python -c "from huggingface_hub import snapshot_download; snapshot_download('microsoft/VibeVoice-ASR')"

# Download VibeVoice-Realtime-0.5B (required for real-time TTS)
python -c "from huggingface_hub import snapshot_download; snapshot_download('microsoft/VibeVoice-Realtime-0.5B')"

# Download Qwen2.5-7B (dependency for ASR)
python -c "from huggingface_hub import snapshot_download; snapshot_download('Qwen/Qwen2.5-7B')"

# Optional: Download VibeVoice-1.5B (for long-form TTS)
python -c "from huggingface_hub import snapshot_download; snapshot_download('microsoft/VibeVoice-1.5B')"
```

#### Model Overview

| Model | Size | Purpose | Storage | Link |
|-------|------|---------|---------|------|
| **VibeVoice-ASR** | 7B | Speech-to-text with speaker diarization | 20GB | [HF](https://huggingface.co/microsoft/VibeVoice-ASR) |
| **VibeVoice-Realtime-0.5B** | 0.5B | Real-time text-to-speech | 3GB | [HF](https://huggingface.co/microsoft/VibeVoice-Realtime-0.5B) |
| **Qwen2.5-7B** | 7B | LLM backbone for ASR | 20GB | [HF](https://huggingface.co/Qwen/Qwen2.5-7B) |
| **VibeVoice-1.5B** | 1.5B | Long-form multi-speaker TTS (optional) | 8GB | [HF](https://huggingface.co/microsoft/VibeVoice-1.5B) |

**Minimum Storage**: 35GB (ASR + Realtime TTS + Qwen2.5-7B)  
**Full Setup**: 60GB+ (all models included)

For detailed model information and download instructions, see [MODEL_WEIGHTS.md](MODEL_WEIGHTS.md).

### Full Documentation

- [VibeVoice-ASR Documentation](docs/vibevoice-asr.md) - Speech-to-text with speaker diarization
- [VibeVoice-TTS Documentation](docs/vibevoice-tts.md) - Long-form multi-speaker synthesis
- [VibeVoice-Realtime Documentation](docs/vibevoice-realtime-0.5b.md) - Real-time streaming TTS
- [vLLM Integration](docs/vibevoice-vllm-asr.md) - Optimized inference for ASR
- [Finetuning Guide](finetuning-asr/README.md) - Custom ASR model training

### Platform-Specific Guides

- [macOS Deployment Guide](DEPLOY_MACOS.md) - Step-by-step setup for macOS
- [Mac mini M4 Pro Optimization](M4_PRO_OPTIMIZATION.md) - Detailed optimization for Apple Silicon
- [Model Weights Guide](MODEL_WEIGHTS.md) - Download and storage information

## System Requirements

### Recommended Specs
- **GPU Memory**: 8GB+ for inference (M4 Pro: integrated with unified memory)
- **RAM**: 16GB+ recommended (M4 Pro 16GB base edition supported)
- **Storage**: Depends on deployment strategy:
  - Minimal (Realtime TTS only): 5GB
  - Standard (ASR + Realtime): 35GB
  - Complete (all models): 60GB+

### Hardware Compatibility
- **NVIDIA GPUs**: CUDA 11.8+ with cuDNN
- **Apple Silicon**: M1/M2/M3/M4 Macs with Metal Performance Shaders (MPS)
  - M4 Pro optimized: Utilizes unified memory architecture for efficient inference
  - Supports both fp32, fp16, and bfloat16 precision
- **AMD/Intel**: CPU inference supported (slower)

### Mac mini M4 Pro Specific Notes
- **Base Configuration**: 10-core CPU (8P+2E), 10-core GPU, 16GB unified memory
- **Recommended Deployment**:
  - Plan A: Realtime-0.5B only (5GB) - optimal for minimal storage
  - Plan B: ASR + Realtime (35GB) - suitable for 512GB SSD
  - Plan C: Full setup - recommend external Thunderbolt SSD
- **Storage Considerations**: 
  - If SSD space < 100GB available, use external storage or quantized models
  - See [DEPLOY_MACOS.md](DEPLOY_MACOS.md) for detailed optimization strategies
- **Memory Management**:
  - 16GB unified memory sufficient for single model inference
  - For multi-model concurrent execution, use sequential loading
  - Enable quantization (INT8) to reduce memory footprint by 50%

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.



## ⚠️ Risks and Limitations


While efforts have been made to optimize it through various techniques, it may still produce outputs that are unexpected, biased, or inaccurate. VibeVoice inherits any biases, errors, or omissions produced by its base model (specifically, Qwen2.5 1.5b in this release).
Potential for Deepfakes and Disinformation: High-quality synthetic speech can be misused to create convincing fake audio content for impersonation, fraud, or spreading disinformation. Users must ensure transcripts are reliable, check content accuracy, and avoid using generated content in misleading ways. Users are expected to use the generated content and to deploy the models in a lawful manner, in full compliance with all applicable laws and regulations in the relevant jurisdictions. It is best practice to disclose the use of AI when sharing AI-generated content.


We do not recommend using VibeVoice in commercial or real-world applications without further testing and development. This model is intended for research and development purposes only. Please use responsibly.

## Star History

![Star History Chart](https://api.star-history.com/svg?repos=Microsoft/vibevoice&type=date&legend=top-left)

## Citation

If you find VibeVoice useful in your research, please cite our papers:

```bibtex
@article{vibevoice-asr,
  title={VibeVoice-ASR: A Long-context Speech Recognition Model with Structured Transcription},
  author={VibeVoice Team},
  journal={arXiv},
  year={2026}
}

@article{vibevoice-tts,
  title={VibeVoice-TTS: Long-form Multi-speaker Text-to-Speech Synthesis},
  author={VibeVoice Team},
  journal={arXiv},
  year={2025}
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

VibeVoice builds upon the excellent work of the following projects:
- [Hugging Face Transformers](https://github.com/huggingface/transformers)
- [Diffusers](https://github.com/huggingface/diffusers)
- [Qwen LLM](https://github.com/QwenLM/Qwen)

## Contact

For questions, issues, or contributions, please visit our [GitHub Issues](https://github.com/microsoft/VibeVoice/issues) page or reach out to the team at VibeVoice@microsoft.com.

## Disclaimer

VibeVoice is an open-source research framework. Users are responsible for ensuring their use complies with all applicable laws and regulations. The generated synthetic speech should not be used for impersonation, fraud, or spreading disinformation.
