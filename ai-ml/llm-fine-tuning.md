# LLM Fine-Tuning & LoRA Cheatsheet

> Reference for PEFT, LoRA/QLoRA parameter-efficient fine-tuning, DeepSpeed Zero stages, and loss explosion troubleshooting.
> Last verified: May 2026 | Version: TRL 0.8+ / PEFT 0.10+ / DeepSpeed 0.14+

---

## Quick Reference

| Tool / Parameter | Recommended Value | Purpose |
|---|---|---|
| LoRA Rank (`r`) | `16` or `32` | Rank dimension for adapter matrices |
| LoRA Alpha (`lora_alpha`) | `32` or `64` | Scaling factor (typically `2 * r`) |
| Target Modules | `["q_proj", "k_proj", "v_proj", "o_proj"]` | Key attention layers for adaptation |
| Learning Rate | `1e-4` to `2e-4` | Safe starting learning rate for LoRA |
| DeepSpeed ZeRO-2 | Partition Gradients + Optimizer States | Single-node multi-GPU fine-tuning |
| DeepSpeed ZeRO-3 | Partition Parameters + Gradients + Optimizer | Multi-node 70B+ model training |

---

## QLoRA Fine-Tuning Script with TRL & SFTTrainer

```python
import torch
from datasets import load_dataset
from transformers import AutoModelForCausalLM, AutoTokenizer, BitsAndBytesConfig, TrainingArguments
from peft import LoraConfig, prepare_model_for_kbit_training, get_peft_model
from trl import SFTTrainer

model_id = "meta-llama/Meta-Llama-3-8B"

# 1. Quantization configuration
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_use_double_quant=True,
    bnb_4bit_compute_dtype=torch.bfloat16
)

model = AutoModelForCausalLM.from_pretrained(
    model_id,
    quantization_config=bnb_config,
    device_map="auto"
)
model = prepare_model_for_kbit_training(model)

# 2. LoRA Adapter Configuration
peft_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj", "gate_proj", "up_proj", "down_proj"],
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM"
)
model = get_peft_model(model, peft_config)
model.print_trainable_parameters()

# 3. Training Arguments
training_args = TrainingArguments(
    output_dir="./lora_checkpoints",
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    learning_rate=2e-4,
    lr_scheduler_type="cosine",
    warmup_ratio=0.03,
    logging_steps=10,
    save_strategy="epoch",
    fp16=False,
    bf16=True,
    optim="paged_adamw_8bit" # Prevents optimizer OOM spikes
)
```

---

## Merging LoRA Weights Back to Base Model

```python
from peft import PeftModel
from transformers import AutoModelForCausalLM, AutoTokenizer

base_model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Meta-Llama-3-8B",
    torch_dtype=torch.bfloat16,
    device_map="cpu"
)

# Merge LoRA adapter into full checkpoint for vLLM or Ollama deployment
model = PeftModel.from_pretrained(base_model, "./lora_checkpoints/final")
merged_model = model.merge_and_unload()
merged_model.save_pretrained("./llama3-8b-finetuned-merged", safe_serialization=True)
```

---

## Troubleshooting & Disaster Recovery

### 1. Training Loss Explodes to `NaN`
- **Root Causes:** Unstable gradient updates in fp16, unnormalized dataset tokens, or excessive learning rate.
- **Recovery Protocol:**
  - Switch precision from `fp16=True` to `bf16=True` (Bfloat16 has same dynamic range as Float32).
  - Add gradient clipping: `max_grad_norm=0.3`.
  - Check dataset for empty prompt strings or sequence length exceeding attention window.
  - Reduce learning rate to `5e-5`.

### 2. Loss Flattens and Fails to Decrease
- **Fix:** Verify target modules. If only training `q_proj` and `v_proj`, expand to MLP feedforward layers (`gate_proj`, `up_proj`, `down_proj`).

---

## Tips & Tricks

- **Paged AdamW:** Use `optim="paged_adamw_8bit"` to automatically offload optimizer state pages to CPU memory when VRAM spikes, preventing OOM.
- **Check GPU utilization:** Run `nvidia-smi dmon -s u` during training to ensure GPU compute stays above 90% and is not bottlenecked by CPU data loading.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
