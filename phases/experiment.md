# Phase: Experiment

## Goal
Run experiments to validate the paper's claims. Work in `.autoresearch/scratch/`. Log everything to `.autoresearch/log.jsonl`.

## Steps

### 1. Read context
- Read `.autoresearch/log.jsonl` — what's been tried
- Read validation targets from the log
- Read relevant papers from `.autoresearch/refs/` for methodology details

### 2. Validation experiments first
Before full runs, do quick sanity checks:
- Reduced data, smaller model, shorter training
- Goal: verify the approach works at all

### 3. Run full experiments
For each validation target:
1. Implement in `.autoresearch/scratch/`
2. Run the experiment
3. Log results immediately to `.autoresearch/log.jsonl`
4. If failed — form hypothesis, modify, re-run

### 4. Iteration rules
- Max 5 attempts per target before sending to judge
- Always change something between attempts
- Log every attempt — failures are data
- If stuck, search for papers addressing the failure, add to `references.bib`

### 5. Update paper
After successful experiments:
- Fill Experiments section in `.autoresearch/paper.tex` with real numbers
- Replace `% TODO: validate` with actual results
- Add new references if discovered

### 6. Proceed to judge
When experiments are done (pass or fail), immediately continue to judge phase.
