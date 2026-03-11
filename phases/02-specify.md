# Phase 2: Specify — Write the Paper Spec

## Objective

Co-write the abstract and introduction with the user. These sections become the **specification** — every claim made here must be validated by experiments. The paper is written FIRST, not after.

## Protocol

### Step 1: Draft the Abstract

Write a structured abstract (200-300 words) covering:

1. **Context** — What problem domain are we in? (1-2 sentences)
2. **Gap** — What's missing from existing work? (1-2 sentences, cite)
3. **Method** — What do we propose? (2-3 sentences)
4. **Results** — What we expect to show (phrased as goals, not claims yet) (1-2 sentences)
5. **Significance** — Why this matters (1 sentence)

Mark any result claims with `% TODO: validate` in the LaTeX.

Present the draft to the user for feedback. Iterate until they approve.

### Step 2: Write the Introduction

Structure the introduction as 4-5 paragraphs:

**Paragraph 1: The Big Picture**
- Broad context of the problem
- Why it matters to the field
- Cite foundational works from `references.bib`

**Paragraph 2: What Exists**
- Survey of current approaches (high-level)
- What they achieve
- Heavy citation from Phase 1 literature review

**Paragraph 3: The Gap**
- What current methods fail to address
- Why this gap is important
- Transition from "what exists" to "what's needed"

**Paragraph 4: Our Approach**
- What we propose
- Key insight or intuition behind the approach
- Brief preview of methodology

**Paragraph 5: Contributions and Outline**
- Bullet list of contributions (each becomes an experiment target)
- Paper outline (sections)

Every contribution listed becomes a **validation target** for Phase 4.

### Step 3: Outline Remaining Sections

In `paper.tex`, create section stubs with TODO comments describing what each will contain:

```latex
\section{Related Work}
% TODO: Expand from literature notes. Group by approach category.

\section{Method}
% TODO: Formal description of proposed approach.
% Key components to describe:
% - [component 1]
% - [component 2]

\section{Experiments}
% TODO: Fill after Phase 4.
\subsection{Setup}
% Datasets, metrics, baselines, hyperparameters
\subsection{Main Results}
% Primary comparison against baselines
\subsection{Ablation Studies}
% Which components matter most

\section{Discussion}
% TODO: Fill after Phase 5 judge evaluation.

\section{Conclusion}
% TODO: Fill after all experiments pass judge.
```

### Step 4: Extract Validation Targets

From the abstract and contributions, extract concrete claims that experiments must validate. Write these to `research_state.json`:

```json
{
  "validation_targets": [
    {
      "id": "VT-001",
      "claim": "Our method achieves comparable quality to dense attention",
      "metric": "perplexity on WikiText-103",
      "threshold": "within 2% of dense baseline",
      "status": "pending"
    },
    {
      "id": "VT-002",
      "claim": "Our method uses 1/4 the compute",
      "metric": "FLOPs per forward pass",
      "threshold": "≤25% of dense attention FLOPs",
      "status": "pending"
    }
  ]
}
```

### Step 5: User Checkpoint

Present to the user:
1. The complete abstract
2. The introduction
3. The validation targets extracted
4. Ask: "Does this capture your research vision? Any claims to add/remove/modify?"

**Do not proceed to Phase 3 until the user confirms.**

### Step 6: Update References

Any new citations introduced in the abstract or intro must be added to `references.bib` with full metadata. Verify each one exists — never fabricate.

## Phase Transition

Update `research_state.json`:
```json
{
  "phase": 3,
  "abstract_approved": true,
  "intro_approved": true,
  "validation_targets": [...],
  "num_references": N
}
```

Log the spec completion to `shared_pool/experience_log.jsonl`.
