# Phase: Ground

## Goal
Find what exists, identify the gap, build `references.bib`, and download key papers for context.

## Steps

### 1. Decompose the question
Break the research question into 3-5 searchable sub-topics.

### 2. Search
For each sub-topic:
- WebSearch with academic keywords (include "arxiv", "paper", recent years)
- WebFetch abstracts from arxiv.org for top results
- For each relevant paper: authors, title, year, venue, key findings, limitations

### 3. Download key papers
For the 5-10 most relevant papers, download the full arxiv HTML:
- WebFetch `https://arxiv.org/html/<id>` and save to `.autoresearch/refs/<citekey>.html`
- These become full-text context for later phases

### 4. Build references.bib
Add BibTeX entries to `references.bib` (in the paper directory). Aim for 15-30 references:
- 3-5 foundational works
- 5-10 direct competitors
- 3-5 methodology papers
- 2-3 benchmark/evaluation papers

### 5. Log findings
Append to `.autoresearch/log.jsonl` a summary entry with the landscape overview, gap identified, hypothesis, and key baselines.

### 6. Write report
Write `.autoresearch/reports/YYYY-MM-DD-ground/report.md`:
- **Research intent** — the user's original question, restated
- **What exists** — key prior work and how it relates to the intent
- **The gap** — what's missing and why it matters for the intent
- **Proposed direction** — hypothesis and how it addresses the gap

### 7. User checkpoint
Present to the user:
1. The gap you found
2. Top 10 papers (title, year, one-line summary)
3. Your hypothesis
4. Ask: "Does this look right? Any papers to add?"

**Stop and wait for user confirmation before proceeding to specify.**
