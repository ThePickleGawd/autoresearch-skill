# Phase 5: Judge — Evaluate Results

## Objective

Critically evaluate whether experimental results validate the paper's claims. The judge is adversarial — it looks for weaknesses, not confirmations. Results must pass the judge before the paper can be completed.

## Protocol

### Step 1: Load Context

Read:
- `paper/paper.tex` — the claims being validated
- `research_state.json` — validation targets and their status
- `shared_pool/experience_log.jsonl` — full experiment history
- `shared_pool/findings.md` — consolidated results
- All `experiments/*/results.json` — raw experiment outputs

### Step 2: Evaluate Each Validation Target

For each target, assess on five criteria:

#### 2a. Statistical Validity
- Are results statistically significant?
- Were experiments run with multiple seeds?
- Are error bars / confidence intervals reported?
- Is the sample size sufficient?

#### 2b. Reproducibility
- Are all hyperparameters documented?
- Is the code deterministic (seeded)?
- Could someone else reproduce these results?

#### 2c. Fairness of Comparison
- Does the baseline use the same compute budget?
- Are comparisons apples-to-apples?
- Are we cherry-picking favorable metrics?
- Do we cite and compare against the strongest baselines? Check `references.bib`.

#### 2d. Claim Alignment
- Does the result actually support the claim in the abstract?
- Is the claim overstated relative to the evidence?
- Are there caveats that should be mentioned?

#### 2e. Completeness
- Are there obvious experiments we should have run but didn't?
- Are ablations sufficient to understand why the method works?
- Are failure cases documented?

### Step 3: Produce Verdict

Write evaluation to `judge/evaluations.jsonl`:

```json
{
  "timestamp": "ISO-8601",
  "iteration": 1,
  "validation_target": "VT-001",
  "verdict": "PASS | FAIL | REVISE",
  "scores": {
    "statistical_validity": 0.8,
    "reproducibility": 0.9,
    "fairness": 0.7,
    "claim_alignment": 0.85,
    "completeness": 0.6
  },
  "issues": [
    "Only tested on one dataset — need at least two",
    "No comparison against FlashAttention-2"
  ],
  "suggestions": [
    "Run on C4 dataset in addition to WikiText-103",
    "Add FlashAttention-2 baseline"
  ],
  "new_directions": [
    "Results suggest method works better on longer sequences — could be a separate contribution"
  ],
  "references_to_add": [
    "Add dao2023flashattention2 to references.bib for fair comparison"
  ]
}
```

### Step 4: Overall Paper Verdict

After evaluating all targets, produce an overall verdict:

- **PASS** — All targets pass with scores ≥ 0.7. Proceed to complete the paper.
- **REVISE** — Some targets need more work. Return to Phase 4 with specific instructions.
- **BRANCH** — Results reveal new directions worth exploring. Proceed to Phase 6.
- **PIVOT** — Fundamental approach isn't working. Present findings to user, discuss alternatives.

### Step 5: Route Based on Verdict

**If PASS:**
- Update `paper/paper.tex`: fill Discussion and Conclusion sections
- Update `references.bib` with any references the judge identified as missing
- Present completed paper to user for final review
- Update `research_state.json`: `"phase": "complete"`

**If REVISE:**
- Log specific issues to `shared_pool/experience_log.jsonl`
- Update validation targets with judge feedback
- Return to Phase 4 with clear instructions on what to fix
- Update `research_state.json`: `"phase": 4, "judge_iteration": N+1`

**If BRANCH:**
- Extract new directions from judge evaluation
- Proceed to Phase 6 to spawn parallel agents
- Update `research_state.json`: `"phase": 6`

**If PIVOT:**
- Present analysis to user: what worked, what didn't, why
- Ask user for direction: abandon, pivot methodology, or narrow scope
- Do NOT proceed without user input

### Step 6: Update References

Add any references the judge identified as missing for fair comparison or proper citation.

## Judge Iteration Limits

- **Max 3 judge iterations** before presenting to user for guidance
- Each iteration should show clear progress on previous issues
- If the same issue persists across 2 iterations, escalate to user
