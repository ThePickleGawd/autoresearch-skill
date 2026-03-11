# Phase: Specify

## Goal
Write the abstract and introduction in the main `.tex` file (see `Paper:` in settings.md). These are the specification — every claim must be validated by experiments.

## Steps

### 1. Draft abstract (200-300 words)
1. **Context** — problem domain (1-2 sentences)
2. **Gap** — what's missing, cite prior work (1-2 sentences)
3. **Method** — what we propose (2-3 sentences)
4. **Expected results** — phrased as goals, not claims yet (1-2 sentences)
5. **Significance** — why it matters (1 sentence)

Mark unvalidated result claims with `% TODO: validate`.

### 2. Write introduction (4-5 paragraphs)
1. Big picture — why this matters, cite foundational works
2. What exists — survey approaches, heavy citation from `references.bib` (in the paper directory)
3. The gap — what's missing, why it matters
4. Our approach — key insight, brief methodology
5. Contributions — bullet list (each becomes a validation target)

### 3. Outline remaining sections
Add section stubs with `% TODO` comments in the main `.tex` file.

### 4. Extract validation targets
From abstract and contributions, extract testable claims. Each target is just what you claim and what evidence would convince you:
```json
{"time":"...","phase":"specify","action":"defined validation targets","targets":[{"claim":"...","evidence":"..."}]}
```

### 5. Update references
Read downloaded papers from `.autoresearch/refs/` for accurate citation details. Add any new citations to `references.bib` (in the paper directory).

### 6. Write report
Write `.autoresearch/reports/YYYY-MM-DD-specify.md`:
- **Research intent** — how the abstract/intro operationalize the user's question
- **Claims made** — each contribution and what evidence would be convincing
- **Validation plan** — what to produce for each claim
- **Risks** — what could prevent the claims from holding

### 7. User checkpoint
Present the abstract, introduction, and validation targets.
Ask: "Does this capture your vision?"

**Stop and wait for user confirmation before proceeding to experiment.**
