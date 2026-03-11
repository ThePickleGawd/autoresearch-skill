# Phase: Judge

## Goal
Evaluate whether results validate the paper's claims. Be adversarial — look for weaknesses.

## Steps

### 1. Load context
- the main `.tex` file — the claims
- `.autoresearch/log.jsonl` — full experiment history
- Experiment outputs in `.autoresearch/scratch/`

### 2. Evaluate each validation target

Score on three criteria (0.0 - 1.0):

**Validity** — Are results statistically sound? Multiple seeds? Reproducible?

**Fairness** — Apples-to-apples comparison? Strongest baselines from `references.bib` (in the paper directory)? Same compute budget?

**Alignment** — Does the evidence support the claim? Any overstatement?

### 3. Verdict

- **PASS** (all scores >= 0.7) — Fill Discussion + Conclusion in the paper. Research complete.
- **REVISE** (fixable issues) — Log specific issues, return to experiment phase.
- **PIVOT** (fundamental problem) — Stop. Present analysis to user. Ask for direction.

Log the verdict to `.autoresearch/log.jsonl`:
```json
{"time":"...","phase":"judge","action":"evaluated","verdict":"REVISE","scores":{"validity":0.8,"fairness":0.5,"alignment":0.9},"issues":["missing FlashAttention-2 baseline"],"next":"add baseline, re-run"}
```

### 4. Write report
Write `.autoresearch/reports/YYYY-MM-DD-judge.md` (or `-judge-N` if repeated) summarizing: scores per target, verdict, issues found, and next action.

### 5. Route

- **PASS** → Complete the paper, update `references.bib` (in the paper directory), tell user it's done.
- **REVISE** → Immediately return to experiment phase. Max 3 judge loops before asking user.
- **PIVOT** → Stop. Present what worked/failed. Ask user what to do next.
