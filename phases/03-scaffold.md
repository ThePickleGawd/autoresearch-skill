# Phase 3: Scaffold — Project Setup

## Objective

Set up the experiment infrastructure: code, data pipelines, evaluation harness, and baseline. After this phase, running an experiment should be a single command.

## Protocol

### Step 1: Analyze Validation Targets

Read `research_state.json` to get the validation targets from Phase 2. For each target, determine:
- What code needs to exist to test this claim
- What data is needed
- What metrics must be computed
- What baseline to compare against

### Step 2: Create Experiment Structure

```
experiments/
├── common/
│   ├── data.py          # Data loading, preprocessing
│   ├── metrics.py       # Evaluation metrics
│   ├── utils.py         # Shared utilities
│   └── config.py        # Experiment configuration
├── baseline/
│   ├── run.py           # Baseline experiment entry point
│   └── config.yaml      # Baseline hyperparameters
└── README.md            # How to run experiments
```

### Step 3: Implement Core Components

**data.py** — Data loading with:
- Deterministic splits (train/val/test)
- Reproducible data ordering (seeded)
- Clear documentation of data source and preprocessing

**metrics.py** — Evaluation with:
- Every metric referenced in validation targets
- Standard computation matching prior work (cite the papers that define these metrics)
- Logging to structured output (JSON)

**config.py** — Configuration with:
- All hyperparameters in one place
- Defaults matching baseline from literature
- Easy override mechanism (CLI args or YAML)

### Step 4: Implement Baseline

The baseline experiment must:
1. Reproduce a known result from literature (within reasonable tolerance)
2. Use the same evaluation pipeline your method will use
3. Produce structured output:

```json
{
  "experiment": "baseline",
  "timestamp": "ISO-8601",
  "config": { ... },
  "results": {
    "metric_name": value,
    ...
  },
  "runtime_seconds": N,
  "hardware": "description"
}
```

### Step 5: Create Run Script

Create a top-level `run_experiment.sh` that:
```bash
#!/bin/bash
# Usage: ./run_experiment.sh <experiment_dir> [--config config.yaml]
# Runs an experiment and logs results to shared_pool
```

The script should:
1. Set random seeds for reproducibility
2. Run the experiment
3. Save results to `experiments/<name>/results.json`
4. Append a summary to `shared_pool/experience_log.jsonl`

### Step 6: Validate the Scaffold

Run the baseline experiment. Verify:
- [ ] It completes without errors
- [ ] Metrics are computed correctly
- [ ] Results are logged to the shared pool
- [ ] Output matches expected format

If baseline results don't match literature, debug before proceeding. Log the baseline result to `shared_pool/findings.md`.

### Step 7: Scaffold Proposed Method

Create `experiments/proposed/` with:
- Skeleton code for the proposed method
- Same interface as baseline (same config format, same metrics)
- TODO comments marking where the key innovations go

Do NOT implement the full method yet — that's Phase 4.

## Phase Transition

Update `research_state.json`:
```json
{
  "phase": 4,
  "scaffold_complete": true,
  "baseline_result": { ... },
  "experiment_dirs": ["baseline", "proposed"]
}
```
