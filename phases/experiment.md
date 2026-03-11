# Phase: Experiment

## Goal
Run experiments to validate the paper's claims. Experiment code lives in the repo (not `.autoresearch/`). Use `.autoresearch/scratch/` only for throwaway outputs, temp files, and intermediate results. Log everything to `.autoresearch/log.jsonl`.

## Steps

### 1. Read context
- Read `.autoresearch/log.jsonl` — what's been tried
- Read validation targets from the log
- Read relevant papers from `.autoresearch/refs/` for methodology details

### 2. Set up dependencies
If experiments need external code, datasets, or tools:
- Clone external repos into `third_party/` in the project root
- Install packages using the project's package manager (see settings.md — default `uv`)
- Read the repo's README/docs for setup instructions
- Download datasets as needed
- Log what was set up to `.autoresearch/log.jsonl`

### 3. Validation experiments first
Before full runs, do quick sanity checks:
- Reduced data, smaller model, shorter training
- Goal: verify the approach works at all

### 4. Run full experiments
For each validation target:
1. Implement in the repo (experiment code is real code)
2. Run the experiment
3. Log results immediately to `.autoresearch/log.jsonl`
4. If failed — form hypothesis, modify, re-run

### 5. Iteration rules
- Max 5 attempts per target before sending to judge
- Always change something between attempts
- Log every attempt — failures are data
- If stuck, search for papers addressing the failure, add to `references.bib` (in the paper directory)

### 6. Update paper
After successful experiments:
- Fill Experiments section in the main `.tex` file with real numbers
- Replace `% TODO: validate` with actual results
- Add new references if discovered

### 7. Write report
Write `.autoresearch/reports/YYYY-MM-DD-experiment.md` (or `-experiment-N` if repeated):
- **Research intent** — what the experiments aimed to show
- **Results vs. claims** — for each validation target: what evidence was produced and whether it's convincing
- **Failures** — what didn't work and the likely reasons (methodology, data, implementation, or fundamental)
- **Confidence** — honest assessment of how well the evidence supports the paper's story

### 8. Proceed to judge
When experiments are done (pass or fail), immediately continue to judge phase.
