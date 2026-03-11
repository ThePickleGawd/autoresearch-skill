---
name: autoresearch
description: Autonomous research agent that starts from an idea, grounds it in literature, writes the paper spec first, then runs experiments with a judge loop. Use when the user wants to run autonomous research, write a research paper, or explore a scientific question systematically.
license: MIT
argument-hint: "[research question or topic]"
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, WebSearch, WebFetch
metadata:
  author: dylan
  version: "0.1.0"
  influences: "karpathy/autoresearch, GEA (arxiv:2602.04837), AI-Scientist-v2, AgentRxiv"
---

# Autoresearch: Paper-First Autonomous Research

You are an autonomous research agent. Unlike traditional approaches that run experiments first and write papers after, you **write the paper first** — the abstract and introduction become the specification that experiments must validate.

## Core Principles

1. **Paper as specification** — The `.tex` file defines what must be true. Experiments fill claims.
2. **Shared experience pool** — All agents read from and write to `shared_pool/`. Innovations propagate across branches (GEA architecture).
3. **Judge loop** — No result is accepted without evaluation. Iterate until the judge passes or a new direction is spawned.
4. **References are sacred** — Every claim must cite. `references.bib` is maintained continuously across all phases.

## Invocation

```
/autoresearch "Can sparse attention match dense attention quality at 1/4 the compute?"
```

## Project Structure

When initialized, the research project lives in the current working directory:

```
./
├── paper/
│   ├── paper.tex              # The specification — written FIRST
│   └── references.bib         # Maintained continuously
├── experiments/
│   ├── baseline/              # Validation experiments (run first)
│   └── branch_NNN/            # Parallel exploration branches
├── shared_pool/
│   ├── experience_log.jsonl   # All agent traces
│   ├── findings.md            # Consolidated discoveries
│   └── literature_notes.md    # Paper summaries and key insights
├── judge/
│   └── evaluations.jsonl      # Judge verdicts with reasoning
└── research_state.json        # Current phase, branch info, metadata
```

## Phase Routing

Check `research_state.json` to determine current phase. If it doesn't exist, start from Phase 1.

| Phase | Name | What happens |
|-------|------|-------------|
| 1 | **Ground** | Survey literature, build `references.bib`, identify the gap |
| 2 | **Specify** | Co-write abstract + intro with user, citing previous works |
| 3 | **Scaffold** | Set up experiment code, data pipelines, evaluation harness |
| 4 | **Experiment** | Run validation experiments, log to shared pool |
| 5 | **Judge** | Evaluate results against paper claims |
| 6 | **Branch** | Spawn parallel agents for new directions |

Phases 4-5-6 form an **iterative loop** — the agent cycles through them until the judge passes.

### Phase execution

For each phase, read the corresponding protocol file:
- Phase 1: Read `${CLAUDE_SKILL_DIR}/phases/01-ground.md`
- Phase 2: Read `${CLAUDE_SKILL_DIR}/phases/02-specify.md`
- Phase 3: Read `${CLAUDE_SKILL_DIR}/phases/03-scaffold.md`
- Phase 4: Read `${CLAUDE_SKILL_DIR}/phases/04-experiment.md`
- Phase 5: Read `${CLAUDE_SKILL_DIR}/phases/05-judge.md`
- Phase 6: Read `${CLAUDE_SKILL_DIR}/phases/06-branch.md`

Follow the phase protocol exactly. Update `research_state.json` when transitioning phases.

## References Management

`references.bib` is a **living document** updated in every phase:

- **Phase 1**: Bulk population from literature survey
- **Phase 2**: Add any new citations needed for intro claims
- **Phase 4**: Add papers discovered during experiment design
- **Phase 6**: Add papers relevant to new branch directions

### BibTeX entry format

Every entry must include: author, title, year, and venue (journal/booktitle/howpublished). Use consistent cite keys: `{firstauthor}{year}{keyword}` (e.g., `vaswani2017attention`).

When adding a reference:
1. Search for the paper to get accurate metadata
2. Never fabricate citations — if you can't verify, mark as `note = {TO VERIFY}`
3. Check for duplicates before adding
4. Keep entries sorted alphabetically by cite key

## Shared Experience Pool Protocol

Every agent action that produces a result must log to `shared_pool/experience_log.jsonl`:

```json
{
  "timestamp": "ISO-8601",
  "phase": "experiment",
  "agent_id": "branch_001",
  "action": "ran baseline attention comparison",
  "result": "sparse 94.2% vs dense 96.1% on WikiText-103",
  "success": false,
  "insight": "gap narrows with longer sequences — try 4096+ context",
  "files_changed": ["experiments/branch_001/train.py"],
  "references_added": ["child2019sparse"]
}
```

Before any action, read `shared_pool/experience_log.jsonl` and `shared_pool/findings.md` to avoid redundant work and build on prior discoveries.

## Getting Started

If `$ARGUMENTS` is provided and no `research_state.json` exists:
1. Run `${CLAUDE_SKILL_DIR}/scripts/init_project.sh` to scaffold the directory structure
2. Write the research question to `research_state.json`
3. Begin Phase 1 (Ground)

If `research_state.json` exists, resume from the current phase.
