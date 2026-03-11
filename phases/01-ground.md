# Phase 1: Ground — Literature Survey

## Objective

Survey existing work to understand the landscape, identify the gap your research will fill, and build the initial `references.bib`. This phase ends with a clear understanding of what exists, what doesn't, and why your idea matters.

## Protocol

### Step 1: Decompose the Research Question

Break the user's research question into 3-5 searchable sub-topics. For example:
- "Can sparse attention match dense attention at 1/4 compute?" decomposes into:
  - Sparse attention mechanisms (existing approaches)
  - Compute efficiency in transformers
  - Quality-compute tradeoffs in attention
  - Recent benchmarks for attention variants

### Step 2: Literature Search

For each sub-topic, perform systematic search:

1. **WebSearch** with academic keywords (include "arxiv", "paper", "2024", "2025", "2026")
2. **WebFetch** abstracts from arxiv.org for top results
3. For each relevant paper found, extract:
   - Full citation metadata (authors, title, year, venue)
   - Key findings (1-2 sentences)
   - Methodology summary
   - Relevance to our research question
   - Limitations or gaps this paper leaves open

### Step 3: Build References

For each relevant paper, add a BibTeX entry to `paper/references.bib`:

```bibtex
@article{vaswani2017attention,
  author    = {Vaswani, Ashish and Shazeer, Noam and Parmar, Niki and Uszkoreit, Jakob and Jones, Llion and Gomez, Aidan N and Kaiser, {\L}ukasz and Polosukhin, Illia},
  title     = {Attention is All You Need},
  journal   = {Advances in Neural Information Processing Systems},
  volume    = {30},
  year      = {2017}
}
```

Aim for 15-30 references covering:
- **Foundational work** (3-5 seminal papers)
- **Direct competitors** (5-10 papers doing similar things)
- **Methodology papers** (3-5 papers whose methods you'll use or extend)
- **Evaluation benchmarks** (2-3 papers defining the metrics you'll use)

### Step 4: Write Literature Notes

Write `shared_pool/literature_notes.md` summarizing:

```markdown
# Literature Notes

## Research Question
[The original question]

## Landscape Summary
[2-3 paragraph overview of the field]

## Key Approaches
### [Approach 1 Name]
- **Papers**: \cite{key1}, \cite{key2}
- **How it works**: ...
- **Strengths**: ...
- **Limitations**: ...

### [Approach 2 Name]
...

## The Gap
[What hasn't been done. Why it matters. This becomes the core of your intro.]

## Baseline Methods
[Which existing methods should we compare against?]

## Evaluation Metrics
[What metrics does the field use? Which will we adopt?]
```

### Step 5: Consolidate Findings

Write to `shared_pool/findings.md`:

```markdown
# Research Findings

## Phase 1: Literature Survey

### Gap Identified
[Clear statement of what's missing]

### Our Hypothesis
[What we believe will work and why]

### Key Prior Results to Beat
| Method | Metric | Value | Paper |
|--------|--------|-------|-------|
| ... | ... | ... | \cite{...} |

### Risks
[What could go wrong with our approach]
```

### Step 6: User Checkpoint

Present to the user:
1. The gap you identified
2. The top 10 most relevant papers (title, year, one-line summary)
3. Your proposed hypothesis
4. Ask: "Does this gap and direction look right? Any papers I should add?"

**Do not proceed to Phase 2 until the user confirms.**

## Phase Transition

Update `research_state.json`:
```json
{
  "phase": 2,
  "research_question": "...",
  "gap": "...",
  "hypothesis": "...",
  "num_references": N,
  "grounding_complete": true
}
```

Log to `shared_pool/experience_log.jsonl` with a summary of literature survey results.
