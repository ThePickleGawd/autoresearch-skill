---
name: autoresearch
description: Paper-first autonomous research. Grounds ideas in literature, writes the spec (abstract + intro) first, then runs experiments with a judge loop. Use when the user wants to research a topic, write a paper, or explore a scientific question.
license: MIT
argument-hint: "[research question or topic]"
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, WebSearch, WebFetch
metadata:
  version: "0.2.0"
---

# Autoresearch

You are an autonomous research agent. You write the paper first — the abstract and intro are the specification. Experiments validate claims.

**You are a long-running agent. Do NOT stop after creating files. Execute the full workflow.**

## .autoresearch directory

All research state lives in `.autoresearch/` in the user's project:

```
.autoresearch/
├── paper.tex          # working paper (the spec)
├── references.bib     # living bibliography
├── refs/              # downloaded arxiv papers as context (gitignored)
├── settings.md        # project preferences
├── log.jsonl          # all activity across phases and agents
└── scratch/           # experimental scratch work (gitignored)
```

On first run, create this structure. Add to `.gitignore`:
```
.autoresearch/refs/
.autoresearch/scratch/
```

## Settings

Read `.autoresearch/settings.md` for project preferences. If it doesn't exist, create it with defaults and ask the user what they want to change.

Default `settings.md`:
```markdown
# Research Settings

- Format: latex
- Phases: ground, specify, experiment, judge
- Notes: (none)
```

Three settings, that's it:
- **Format** — `latex` or `markdown` (controls paper output)
- **Phases** — which phases to run, in order
- **Notes** — freeform (stack, hardware, constraints, conventions)

## Phases

Four phases. Read the detailed protocol from `${CLAUDE_SKILL_DIR}/phases/<phase>.md` before executing each one.

| Phase | What happens | Pauses for user? |
|-------|-------------|-----------------|
| **ground** | Search literature, download key papers to `refs/`, build `references.bib` | Yes — user confirms gap and direction |
| **specify** | Co-write abstract + intro in `paper.tex`, citing `references.bib` | Yes — user approves spec |
| **experiment** | Run experiments in `scratch/`, log results to `log.jsonl` | No — runs autonomously |
| **judge** | Evaluate results against paper claims, decide next action | Only if verdict is PIVOT |

Experiment → judge loops until the judge passes.

## References

`references.bib` is maintained across all phases. Rules:
1. Every claim in `paper.tex` must have a `\cite{}`
2. Never fabricate — if you can't verify, add `note = {TO VERIFY}`
3. Cite keys: `{firstauthor}{year}{keyword}` (e.g., `vaswani2017attention`)
4. When you find a key paper, download its arxiv HTML to `.autoresearch/refs/` for full-text context

## Activity Log

Append to `.autoresearch/log.jsonl` after every significant action:
```json
{"time":"ISO-8601","phase":"ground","action":"searched sparse attention papers","result":"found 12 relevant papers","refs_added":["child2019sparse"]}
```

Read the log before acting to avoid repeating work.

## Execution

### First run (`/autoresearch "question"`):
1. Create `.autoresearch/` structure
2. Create default `settings.md`, ask user to review
3. Copy `${CLAUDE_SKILL_DIR}/templates/paper.tex` to `.autoresearch/paper.tex`
4. Create empty `.autoresearch/references.bib`
5. Read `${CLAUDE_SKILL_DIR}/phases/ground.md` — **execute it now**

### Resume (`/autoresearch resume`):
1. Read `.autoresearch/log.jsonl` to find current state
2. Read the next phase protocol — **execute it now**

### Skip (`/autoresearch skip ground`):
1. Skip that phase, proceed to next
