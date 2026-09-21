# Local LLM Serving & Inference Cheatsheet

> Production guide for vLLM, Ollama, llama.cpp, continuous batching, tensor parallelism, and serving latency optimization.
> Last verified: May 2026 | Version: vLLM 0.4+ / Ollama 0.1.30+

---

## Quick Reference

| Engine | Ideal For | Command / API |
|---|---|---|
| **vLLM** | High-throughput enterprise production API | `python -m vllm.entrypoints.openai.api_server` |
| **Ollama** | Local desktop & developer workstation | `ollama run llama3:8b` |
| **llama.cpp** | CPU inference, Apple Silicon, embedded | `./llama-cli -m model.gguf -p "Prompt"` |
| **TGI** | Hugging Face ecosystem hosting | `docker run ghcr.io/huggingface/text-generation-inference` |

---

## vLLM Production OpenAI-Compatible Server

### Single-GPU Launch
```bash
python -m vllm.entrypoints.openai.api_server \
  --model meta-llama/Meta-Llama-3-8B-Instruct \
  --port 8000 \
  --gpu-memory-utilization 0.90 \
  --max-model-len 8192 \
  --dtype bfloat16 \
  --disable-log-requests
```

### Multi-GPU Launch (Tensor Parallelism)
```bash
# Split 70B model across 4 GPUs
python -m vllm.entrypoints.openai.api_server \
  --model meta-llama/Meta-Llama-3-70B-Instruct \
  --tensor-parallel-size 4 \
  --pipeline-parallel-size 1 \
  --port 8000 \
  --gpu-memory-utilization 0.95
```

---

## Ollama Command Reference

```bash
# Pull model from registry
ollama pull mistral:7b

# Run interactive CLI session
ollama run llama3:8b

# List active models running in GPU VRAM
ollama ps

# Create custom model from Modelfile
cat << 'EOF' > Modelfile
FROM llama3:8b
PARAMETER temperature 0.2
PARAMETER top_p 0.9
SYSTEM "You are a senior Linux kernel engineer."
EOF

ollama create dev-llama -f Modelfile

# Stop running model to free VRAM
ollama stop llama3:8b
```

---

## Benchmarking & Client API Query

```bash
# Test vLLM OpenAI-compatible endpoint
curl http://localhost:8000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Meta-Llama-3-8B-Instruct",
    "messages": [{"role": "user", "content": "How do I troubleshoot high load average?"}],
    "temperature": 0.7,
    "max_tokens": 256
  }'
```

---

## Troubleshooting & Crash Recovery

### 1. `Engine crashed: CUDA out of memory during KV Cache allocation`
- **Root Cause:** `--gpu-memory-utilization` set too high, leaving no space for dynamic KV cache activation.
- **Recovery:**
  - Reduce `--gpu-memory-utilization` to `0.85` or `0.80`.
  - Cap maximum context length: `--max-model-len 4096`.

### 2. High Time-To-First-Token (TTFT)
- **Fix:** Enable Chunked Prefill:
  ```bash
  --enable-chunked-prefill
  ```

### 3. NCCL / Peer-to-Peer Transport Error on Multi-GPU
- **Recovery:** Disable buggy NVLink/P2P fallbacks:
  ```bash
  export NCCL_P2P_DISABLE=1
  export NCCL_IB_DISABLE=1
  ```

---

## Tips & Tricks

- **AWQ / GPTQ quantization:** Deploy models with `--quantization awq` to cut VRAM usage in half with negligible perplexity degradation.
- **Prefix Caching:** Pass `--enable-prefix-caching` in vLLM to reuse KV cache across repeated system prompts, speeding up multi-turn conversations by up to 5x.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
