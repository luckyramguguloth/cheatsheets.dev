# MLOps & Model Evaluation Cheatsheet

> Reference guide for MLflow tracking, Weights & Biases (W&B), model drift detection, benchmark evaluation, and production monitoring.
> Last verified: May 2026 | Version: MLflow 2.13+ / Wandb 0.17+

---

## Quick Reference

| Tool / Metric | Command / Usage | Purpose |
|---|---|---|
| Start Local MLflow UI | `mlflow ui --port 5000` | Local experiment tracking dashboard |
| W&B Login | `wandb login <api_key>` | Authenticate Weights & Biases |
| Perplexity (PPL) | `exp(cross_entropy_loss)` | Language model fluency metric |
| BLEU / ROUGE | `evaluate.load("rouge")` | Text generation overlap benchmark |
| Prometheus AI Exporter | `curl http://localhost:8000/metrics` | vLLM/TGI real-time inference telemetry |

---

## Experiment Tracking with Weights & Biases (W&B)

```python
import wandb

# Initialize run
run = wandb.init(
    project="llm-finetuning-prod",
    config={
        "learning_rate": 2e-4,
        "batch_size": 16,
        "lora_rank": 32,
        "optimizer": "paged_adamw_8bit"
    }
)

# Log step metrics inside training loop
for step, (loss, grad_norm, lr) in enumerate(training_loop):
    wandb.log({
        "train/loss": loss,
        "train/grad_norm": grad_norm,
        "train/learning_rate": lr
    }, step=step)

# Finish run
wandb.finish()
```

---

## Tracking Model Artifacts with MLflow

```python
import mlflow
import mlflow.pytorch

mlflow.set_tracking_uri("http://localhost:5000")
mlflow.set_experiment("fraud_detection_v2")

with mlflow.start_run(run_name="xgboost_baseline"):
    mlflow.log_params({"max_depth": 6, "n_estimators": 100})
    mlflow.log_metrics({"val_f1_score": 0.942, "val_precision": 0.961})
    
    # Save model artifact into registry
    mlflow.pytorch.log_model(model, artifact_path="model", registered_model_name="FraudModelProd")
```

---

## Data Drift & Model Monitoring

```python
# Statistical Kolmogorov-Smirnov test for feature drift
from scipy.stats import ks_2samp

def detect_drift(baseline_feature, live_feature, threshold=0.05):
    statistic, p_value = ks_2samp(baseline_feature, live_feature)
    is_drifted = p_value < threshold
    return {"drift_detected": is_drifted, "p_value": p_value}
```

---

## Troubleshooting & Recovery

### 1. Wandb Hangs or Blocks Training on Network Drop
- **Recovery:** Run in offline mode, then sync after run completes:
  ```bash
  export WANDB_MODE=offline
  # Run training script...
  # Later, sync all logs:
  wandb sync wandb/offline-run-*
  ```

### 2. MLflow Artifact Store Upload Timeout
- **Fix:** Increase timeout for large model checkpoints:
  ```bash
  export MLFLOW_HTTP_REQUEST_TIMEOUT=600
  ```

---

## Tips & Tricks

- **Log system hardware metrics:** W&B automatically logs CPU, GPU, memory, and network utilization in background threads without slowing down the model loop.
- **Model Signature:** Always register explicit input/output tensor signatures in MLflow to prevent production inference schema mismatches.

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
