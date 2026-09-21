# Hugging Face Transformers Cheatsheet

> Reference for Transformers pipeline inference, AutoModel architecture, tokenization, device mapping, quantization, and memory crash handling.
> Last verified: May 2026 | Version: Transformers 4.40+ / PEFT 0.10+

---

## Quick Reference

| Task / Feature | Code Snippet |
|---|---|
| Load 4-bit Quantized Model | `AutoModelForCausalLM.from_pretrained(id, load_in_4bit=True, device_map="auto")` |
| Load 8-bit Quantized Model | `AutoModelForCausalLM.from_pretrained(id, load_in_8bit=True, device_map="auto")` |
| Fast Tokenizer Loading | `AutoTokenizer.from_pretrained(id, use_fast=True)` |
| Offload to CPU/Disk | `device_map="auto", offload_folder="./offload"` |
| FlashAttention-2 | `AutoModelForCausalLM.from_pretrained(id, attn_implementation="flash_attention_2")` |
| Generate without gradients | `with torch.inference_mode(): output = model.generate(**inputs)` |

---

## Production Model Loading (4-bit BitsAndBytes Quantization)

```python
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig

model_id = "meta-llama/Meta-Llama-3-8B-Instruct"

# 4-bit NormalFloat (NF4) configuration with double quantization
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_use_double_quant=True,
    bnb_4bit_compute_dtype=torch.bfloat16
)

tokenizer = AutoTokenizer.from_pretrained(model_id, use_fast=True)
# Ensure pad token exists to prevent batch generation crash
if tokenizer.pad_token is None:
    tokenizer.pad_token = tokenizer.eos_token

model = AutoModelForCausalLM.from_pretrained(
    model_id,
    quantization_config=bnb_config,
    device_map="auto",
    torch_dtype=torch.bfloat16,
    low_cpu_mem_usage=True
)
```

---

## Robust Generation with Streaming

```python
from transformers import TextIteratorStreamer
from threading import Thread

messages = [
    {"role": "system", "content": "You are an expert systems engineer."},
    {"role": "user", "content": "Explain kernel panic troubleshooting."}
]

prompt = tokenizer.apply_chat_template(messages, tokenize=False, add_generation_prompt=True)
inputs = tokenizer(prompt, return_tensors="pt").to("cuda")

streamer = TextIteratorStreamer(tokenizer, skip_prompt=True, skip_special_tokens=True)
generation_kwargs = dict(
    inputs,
    streamer=streamer,
    max_new_tokens=512,
    do_sample=True,
    temperature=0.7,
    top_p=0.9,
    pad_token_id=tokenizer.eos_token_id
)

thread = Thread(target=model.generate, kwargs=generation_kwargs)
thread.start()

for new_text in streamer:
    print(new_text, end="", flush=True)
```

---

## Troubleshooting & Recovery

### 1. `ValueError: Tokenizer class does not have a pad_token`
- **Crash Cause:** Generating sequences with batch size > 1 crashes when padding token is unset.
- **Fix:**
  ```python
  tokenizer.pad_token = tokenizer.eos_token
  model.config.pad_token_id = model.config.eos_token_id
  ```

### 2. `RuntimeError: CUDA error: device-side assert triggered`
- **Diagnosis:** Index out of bounds in embedding layer. Tokens in input IDs exceed `vocab_size`.
- **Debugging & Recovery:**
  ```bash
  # Enable synchronous CUDA error reporting to isolate line number:
  export CUDA_LAUNCH_BLOCKING=1
  ```
  ```python
  # Verify input tensor range:
  assert (inputs["input_ids"] < model.config.vocab_size).all(), "Token index exceeds vocabulary limit!"
  ```

### 3. FlashAttention Installation Failure
- **Fix:** FlashAttention requires exact CUDA header matching. Install pre-built binary wheel:
  ```bash
  pip install flash-attn --no-build-isolation
  ```

---

## Tips & Tricks

- **Safe model offloading:** If GPU memory is tight, inspect layer placement with:
  ```python
  print(model.hf_device_map)
  ```
- **Faster downloads:** Install `pip install hf_transfer` and set `export HF_HUB_ENABLE_HF_TRANSFER=1` for multi-threaded gigabit downloads from Hugging Face Hub.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
