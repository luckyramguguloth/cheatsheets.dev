# PyTorch Cheatsheet

> Production reference for PyTorch tensor manipulation, autograd, Distributed Data Parallel (DDP), mixed precision (AMP), and CUDA OOM crash recovery.
> Last verified: May 2026 | Version: PyTorch 2.3+ / 2.4+

---

## Quick Reference

| Operation | Syntax |
|---|---|
| Check CUDA availability | `torch.cuda.is_available()` |
| Query device name | `torch.cuda.get_device_name(0)` |
| Empty GPU cache | `torch.cuda.empty_cache()` |
| Set device | `device = torch.device("cuda" if torch.cuda.is_available() else "cpu")` |
| Move tensor/model to GPU | `x = x.to(device, non_blocking=True)` |
| Enable Mixed Precision | `with torch.autocast(device_type="cuda", dtype=torch.bfloat16):` |
| Compile model (PyTorch 2.x) | `model = torch.compile(model, mode="reduce-overhead")` |
| Save checkpoint | `torch.save({"epoch": ep, "state_dict": model.state_dict(), "opt": opt.state_dict()}, "ckpt.pt")` |
| Load checkpoint | `ckpt = torch.load("ckpt.pt", map_location=device); model.load_state_dict(ckpt["state_dict"])` |

---

## Tensor Operations & Memory Layout

```python
import torch

# Contiguous memory check & memory formatting
x = torch.randn(32, 3, 224, 224, device="cuda")
x_channels_last = x.to(memory_format=torch.channels_last)  # 20-30% speedup on NVIDIA Tensor Cores

# In-place vs out-of-place (in-place saves VRAM but breaks autograd if modified in graph)
x.add_(1.0)  # In-place addition
y = x + 1.0  # Creates new tensor allocation

# Slicing without copying (shares storage)
view_x = x.view(32, -1)     # Requires tensor.is_contiguous() == True
reshape_x = x.reshape(32, -1) # Clones only if non-contiguous
```

---

## Training Loop with Automatic Mixed Precision (AMP) & Gradient Accumulation

```python
import torch
from torch.cuda.amp import GradScaler

model = MyModel().to("cuda")
optimizer = torch.optim.AdamW(model.parameters(), lr=1e-4, weight_decay=1e-2)
scaler = GradScaler()
accum_steps = 4  # Effective batch size = batch_size * 4

model.train()
optimizer.zero_grad(set_to_none=True) # set_to_none=True saves memory over zero_grad()

for step, (inputs, targets) in enumerate(dataloader):
    inputs, targets = inputs.to("cuda", non_blocking=True), targets.to("cuda", non_blocking=True)
    
    with torch.autocast(device_type="cuda", dtype=torch.bfloat16): # or torch.float16
        outputs = model(inputs)
        loss = criterion(outputs, targets)
        loss = loss / accum_steps

    # Backward pass with scaled loss (prevents underflow in float16)
    scaler.scale(loss).backward()
    
    if (step + 1) % accum_steps == 0:
        # Gradient clipping
        scaler.unscale_(optimizer)
        torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
        
        scaler.step(optimizer)
        scaler.update()
        optimizer.zero_grad(set_to_none=True)
```

---

## Distributed Data Parallel (DDP) Initialization

```python
import os
import torch
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP
from torch.utils.data.distributed import DistributedSampler

def setup_ddp():
    dist.init_process_group(backend="nccl")
    local_rank = int(os.environ["LOCAL_RANK"])
    torch.cuda.set_device(local_rank)
    return local_rank

def cleanup_ddp():
    dist.destroy_process_group()

# Launch via torchrun:
# torchrun --nproc_per_node=4 --nnodes=1 train.py
```

---

## Troubleshooting & Crash Recovery

### 1. `torch.cuda.OutOfMemoryError: CUDA out of memory`
- **Immediate Recovery Action:**
  ```python
  # 1. Clear cached memory allocations
  import gc
  gc.collect()
  torch.cuda.empty_cache()
  
  # 2. Monitor reserved vs allocated memory
  print(f"Allocated: {torch.cuda.memory_allocated() / 1e9:.2f} GB")
  print(f"Reserved:  {torch.cuda.memory_reserved() / 1e9:.2f} GB")
  ```
- **Architectural Fixes:**
  - Lower per-device batch size and increase gradient accumulation steps.
  - Enable gradient checkpointing to trade compute for memory:
    ```python
    model.gradient_checkpointing_enable()
    ```
  - Use `set_to_none=True` on `optimizer.zero_grad()`.
  - Set PyTorch memory allocator environment variable:
    ```bash
    export PYTORCH_CUDA_ALLOC_CONF="expandable_segments:True,garbage_collection_threshold:0.8"
    ```

### 2. `RuntimeError: Expected all tensors to be on the same device`
- **Diagnosis:** One parameter or buffer was omitted during `.to(device)` or instantiated dynamically inside `forward()`.
- **Fix:** Register buffers properly:
  ```python
  # Wrong: self.mask = torch.ones(10)
  # Correct:
  self.register_buffer("mask", torch.ones(10))
  ```

### 3. NCCL Watchdog Timeout in Multi-GPU Training
- **Diagnosis:** One GPU hang or divergence caused deadlocks across barrier synchronization.
- **Fix:**
  ```bash
  export NCCL_DEBUG=INFO
  export NCCL_DEBUG_SUBSYS=ALL
  export TORCH_DISTRIBUTED_DEBUG=DETAIL
  export NCCL_ASYNC_ERROR_HANDLING=1
  ```

---

## Tips & Tricks

- **DataLoader speedup:** Always specify `num_workers=4`, `pin_memory=True`, and `persistent_workers=True` on GPU machines to prevent CPU data starvation.
- **Benchmark cudnn:** Add `torch.backends.cudnn.benchmark = True` at the top of training scripts for fixed input tensor shapes.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
