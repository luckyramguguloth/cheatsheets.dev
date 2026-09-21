# TensorFlow & Keras Cheatsheet

> Reference guide for TensorFlow 2.x, Keras 3, mixed precision, multi-worker distributed training, and hardware crash diagnosis.
> Last verified: May 2026 | Version: TensorFlow 2.16+ / Keras 3+

---

## Quick Reference

| Command / API | Description |
|---|---|
| `tf.config.list_physical_devices('GPU')` | List all visible physical GPUs |
| `tf.keras.mixed_precision.set_global_policy('mixed_float16')` | Enable mixed precision training |
| `tf.data.AUTOTUNE` | Automatic optimization for dataset pipeline |
| `tf.distribute.MirroredStrategy()` | Synchronous multi-GPU training on one machine |
| `tf.keras.models.save_model(model, "path.keras")` | Save model in modern Keras v3 format |
| `tf.config.experimental.set_memory_growth(gpu, True)` | Allocate GPU VRAM on demand (prevent 100% lockup) |

---

## GPU Memory Allocation Setup

```python
import tensorflow as tf

# Must be invoked at the very beginning of the script before any tensor operations
gpus = tf.config.list_physical_devices('GPU')
if gpus:
    try:
        for gpu in gpus:
            # Prevent TensorFlow from grabbing 100% of VRAM on startup
            tf.config.experimental.set_memory_growth(gpu, True)
        print(f"Initialized {len(gpus)} GPU(s) with dynamic memory growth.")
    except RuntimeError as e:
        print(f"Memory growth must be set before GPUs have been initialized: {e}")
```

---

## High-Performance `tf.data` Pipeline

```python
def create_dataset(file_paths, batch_size=64):
    dataset = tf.data.TFRecordDataset(file_paths, num_parallel_reads=tf.data.AUTOTUNE)
    dataset = dataset.map(parse_record_fn, num_parallel_calls=tf.data.AUTOTUNE)
    dataset = dataset.shuffle(buffer_size=10000)
    dataset = dataset.batch(batch_size, drop_remainder=True)
    dataset = dataset.prefetch(buffer_size=tf.data.AUTOTUNE)
    return dataset
```

---

## Distributed Multi-GPU Training (`MirroredStrategy`)

```python
import tensorflow as tf

strategy = tf.distribute.MirroredStrategy()
print(f"Number of distributed compute devices: {strategy.num_replicas_in_sync}")

# Model creation, compilation, and loading must reside inside strategy scope
with strategy.scope():
    model = tf.keras.Sequential([
        tf.keras.layers.Input(shape=(224, 224, 3)),
        tf.keras.layers.Conv2D(64, 3, activation='relu'),
        tf.keras.layers.GlobalAveragePooling2D(),
        tf.keras.layers.Dense(10, activation='softmax')
    ])
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=1e-3),
        loss=tf.keras.losses.CategoricalCrossentropy(),
        metrics=['accuracy']
    )

# Model checkpoints with automatic recovery
callbacks = [
    tf.keras.callbacks.ModelCheckpoint(
        filepath="checkpoints/model_epoch_{epoch:02d}.keras",
        save_best_only=True,
        monitor="val_loss"
    ),
    tf.keras.callbacks.EarlyStopping(monitor="val_loss", patience=5)
]

# model.fit(train_ds, validation_data=val_ds, epochs=50, callbacks=callbacks)
```

---

## Troubleshooting & Crash Recovery

### 1. `ResourceExhaustedError: OOM when allocating tensor`
- **Immediate Fix:** Reduce batch size or enable mixed precision:
  ```python
  from tensorflow.keras import mixed_precision
  mixed_precision.set_global_policy('mixed_float16')
  ```
- **Clear backend session:**
  ```python
  tf.keras.backend.clear_session()
  ```

### 2. `Blas GEMM launch failed` / GPU Initialization Errors
- **Diagnosis:** CUDA driver mismatch or zombie Python process locking the GPU memory.
- **Terminal Recovery Commands:**
  ```bash
  # Find and kill lingering TensorFlow processes
  fuser -v /dev/nvidia*
  kill -9 $(fuser -v /dev/nvidia* 2>/dev/null | awk '{print $NF}')
  ```

---

## Tips & Tricks

- **XLA Compilation:** Speed up computation graph execution by adding `jit_compile=True` inside `model.compile(..., jit_compile=True)`.
- **Keras 3 Compatibility:** Modern Keras (`keras.io`) runs interchangeably across TensorFlow, PyTorch, and JAX backends via `os.environ["KERAS_BACKEND"] = "torch"`.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
