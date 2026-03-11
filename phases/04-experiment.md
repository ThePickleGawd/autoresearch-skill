# Phase 4: Experiment — Run and Iterate

## Objective

Implement and run experiments to validate the claims in the paper. Start with validation experiments (small-scale sanity checks), then scale up. Log everything to the shared pool.

## Protocol

### Step 1: Read Shared Pool

Before any experiment:
1. Read `shared_pool/experience_log.jsonl` — what's been tried, what worked, what failed
2. Read `shared_pool/findings.md` — consolidated insights
3. Read `research_state.json` — which validation targets remain pending

Never repeat a failed experiment without changing something. If another agent already tried an approach and it failed, learn from their trace.

### Step 2: Prioritize Validation Targets

Order targets by:
1. **Feasibility** — Can we test this with current compute?
2. **Foundational** — Does this gate other experiments? (do it first)
3. **Risk** — What's most likely to fail? (test early to fail fast)

### Step 3: Validation Experiments (Small Scale)

Before any full experiment, run a **validation experiment**:
- Reduced data (10% of dataset or toy dataset)
- Reduced model size
- Reduced training time
- Goal: verify the approach works at all, not final numbers

If validation fails, iterate on the method before scaling up. Log each attempt.

### Step 4: Run Full Experiments

For each validation target:

1. **Implement** the method changes needed
2. **Configure** hyperparameters (start from literature defaults)
3. **Run** the experiment
4. **Log** results immediately:

```jsonl
{"timestamp":"...","phase":"experiment","agent_id":"main","action":"ran proposed method v1","validation_target":"VT-001","result":"perplexity 23.4 vs baseline 22.1 (5.9% worse)","success":false,"insight":"learning rate may be too high for sparse patterns","files_changed":["experiments/proposed/run.py"],"references_added":[]}
```

5. **Analyze** — Compare against baseline and validation target thresholds
6. **Iterate** — If failed, form hypothesis for why, modify, re-run

### Step 5: Ablation Studies

Once main results pass, run ablations:
- Remove each component one at a time
- Measure impact on primary metric
- This fills the Ablation section of the paper

### Step 6: Update Paper

After successful experiments:
1. Fill in the **Experiments** section of `paper.tex` with actual numbers
2. Replace `% TODO: validate` comments with real results
3. Add any new references discovered during experimentation to `references.bib`
4. Create figures/tables summarizing results

### Step 7: Update Findings

Write consolidated results to `shared_pool/findings.md`:
```markdown
## Phase 4: Experiment Results

### Successful Validations
- VT-001: PASSED — perplexity 22.3 vs baseline 22.1 (within 2% threshold)
- VT-002: PASSED — FLOPs 24.1% of dense (within 25% threshold)

### Failed Validations
- VT-003: FAILED — latency 1.8x baseline (target was ≤1.2x)

### Key Insights
- [insight 1]
- [insight 2]

### Open Questions
- [question that might become a new branch]
```

## Iteration Rules

- **Max 5 attempts** per validation target before escalating to the judge
- **Always change something** between attempts — never re-run the exact same experiment
- **Log every attempt** — failed experiments are valuable data
- **Check references** — if stuck, search for papers that address the specific failure mode and add to `references.bib`

## Phase Transition

When all experiments are complete (pass or fail), move to Phase 5 (Judge):
```json
{
  "phase": 5,
  "experiments_complete": true,
  "results_summary": { ... }
}
```
