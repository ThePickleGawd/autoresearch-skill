# Judge Evaluation Rubric

## Scoring Guide (0.0 - 1.0)

### Statistical Validity

| Score | Criteria |
|-------|----------|
| 0.0-0.3 | No variance reporting, single run, no seeds |
| 0.4-0.6 | Multiple runs but no confidence intervals, limited seeds |
| 0.7-0.8 | 3+ seeds, std reported, results consistent |
| 0.9-1.0 | 5+ seeds, confidence intervals, significance tests where appropriate |

### Reproducibility

| Score | Criteria |
|-------|----------|
| 0.0-0.3 | Missing hyperparameters, no seeds, unclear setup |
| 0.4-0.6 | Most hyperparameters documented, seeds set but not all reported |
| 0.7-0.8 | All hyperparameters documented, deterministic, clear instructions |
| 0.9-1.0 | Full config files, hardware specified, expected runtime, one-command reproduction |

### Fairness of Comparison

| Score | Criteria |
|-------|----------|
| 0.0-0.3 | Missing strong baselines, unfair compute budgets |
| 0.4-0.6 | Reasonable baselines but not SOTA, some compute asymmetry |
| 0.7-0.8 | Strong baselines from recent literature, equal compute, same evaluation |
| 0.9-1.0 | All relevant SOTA baselines, identical conditions, results cross-verified |

### Claim Alignment

| Score | Criteria |
|-------|----------|
| 0.0-0.3 | Claims not supported by data, major overstatement |
| 0.4-0.6 | Claims partially supported, some overstatement |
| 0.7-0.8 | Claims well-supported, appropriate caveats |
| 0.9-1.0 | Claims precisely match evidence, limitations acknowledged |

### Completeness

| Score | Criteria |
|-------|----------|
| 0.0-0.3 | Missing obvious experiments, no ablations |
| 0.4-0.6 | Main experiments done but gaps in ablations or analysis |
| 0.7-0.8 | Thorough experiments, key ablations, failure cases noted |
| 0.9-1.0 | Comprehensive coverage, all components ablated, scaling analysis, failure analysis |

## Verdict Thresholds

- **PASS**: All criteria ≥ 0.7, average ≥ 0.8
- **REVISE**: Any criterion < 0.7 but fixable with more experiments
- **BRANCH**: Results suggest unexplored directions worth pursuing
- **PIVOT**: Average < 0.4 or fundamental methodology issue
