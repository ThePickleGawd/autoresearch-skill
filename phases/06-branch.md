# Phase 6: Branch — Parallel Exploration

## Objective

When findings suggest multiple promising directions, spawn parallel research agents. Each agent explores a different direction independently while sharing discoveries through the experience pool (GEA architecture).

## Protocol

### Step 1: Identify Branch Directions

From the judge evaluation and experiment findings, extract distinct research directions. Each direction must:
- Be independent enough to explore in parallel
- Have a clear hypothesis
- Have a testable validation target
- Build on existing findings (not start from scratch)

### Step 2: Performance-Novelty Selection (GEA)

If resuming from previous branches, select parent approaches using GEA's scoring:

```
score(approach) = performance(approach) * sqrt(novelty(approach))
```

Where:
- **Performance** = how well the approach scored on validation targets
- **Novelty** = cosine distance from other approaches (prevents convergence to one strategy)

Select the top approaches as "parents" for the next generation.

### Step 3: Prepare Branch Context

For each branch direction, prepare a context package:

```json
{
  "branch_id": "branch_001",
  "parent": "main",
  "direction": "Explore longer sequence lengths where sparse attention excels",
  "hypothesis": "Sparse attention quality improves relative to dense at 4096+ tokens",
  "validation_targets": [
    {
      "id": "VT-B001-001",
      "claim": "Quality gap closes to <1% at 8192 token sequences",
      "metric": "perplexity",
      "threshold": "within 1% of dense baseline"
    }
  ],
  "relevant_findings": ["sparse narrows gap at longer sequences", "..."],
  "relevant_references": ["child2019sparse", "beltagy2020longformer"]
}
```

### Step 4: Spawn Parallel Agents

Use the Agent tool to spawn one subagent per branch direction:

```
For each branch:
1. Create `experiments/branch_NNN/` directory
2. Copy relevant experiment code from parent
3. Write branch context to `experiments/branch_NNN/context.json`
4. Spawn agent with instructions to:
   a. Read shared_pool/ for all prior experience
   b. Read its branch context
   c. Execute Phase 4 (Experiment) for its specific targets
   d. Write results to shared_pool/experience_log.jsonl
   e. Update shared_pool/findings.md with discoveries
   f. Add any new references to paper/references.bib
```

**Agent prompt template:**
```
You are a research agent exploring branch "{direction}".

Your hypothesis: {hypothesis}
Your validation targets: {targets}

IMPORTANT:
- Read shared_pool/experience_log.jsonl FIRST — learn from all prior work
- Read shared_pool/findings.md for consolidated insights
- Run experiments in experiments/{branch_id}/
- Log ALL results to shared_pool/experience_log.jsonl
- Update shared_pool/findings.md with your discoveries
- Add new references to paper/references.bib (never duplicate, check first)
- You have a budget of {max_iterations} experiment iterations

When done, write your summary to experiments/{branch_id}/summary.md
```

### Step 5: Collect and Consolidate

After all branch agents complete:

1. **Read** all branch summaries
2. **Merge** findings into `shared_pool/findings.md`
3. **Deduplicate** `references.bib` (agents may have added the same papers)
4. **Update** `shared_pool/experience_log.jsonl` with consolidation entry
5. **Identify** which branches produced the best results

### Step 6: Integrate Best Results

From the branch results:
1. Select the best-performing approaches
2. Update `paper/paper.tex` with new findings
3. Add new sections or subsections if branches revealed unexpected results
4. Update validation targets in `research_state.json`

### Step 7: Return to Judge

After integration, return to Phase 5 for re-evaluation:

```json
{
  "phase": 5,
  "branches_explored": ["branch_001", "branch_002", "branch_003"],
  "best_branch": "branch_002",
  "judge_iteration": N+1
}
```

## Recursive Branching

Branches can themselves spawn sub-branches if their findings suggest further directions. This creates the RLM (Recursive Language Model) pattern of infinite subagents. Constraints:

- **Max depth**: 3 levels of branching (main → branch → sub-branch)
- **Max total branches**: 10 (to bound compute cost)
- **Each branch reads the FULL shared pool** — innovations propagate up, not just within branches
- **Convergence check**: If 3+ branches converge on the same approach, consolidate and stop branching

## Experience Pool Update

After branching, the shared pool should contain traces from ALL branches. The next generation of agents (or the judge) benefits from the full diversity of exploration — this is what makes GEA outperform tree-structured evolution.
