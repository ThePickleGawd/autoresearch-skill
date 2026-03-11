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
├── paper/             # paper directory (or user's extracted conference zip)
│   ├── main.tex       # main file (auto-detected)
│   └── references.bib # living bibliography
├── refs/              # downloaded arxiv papers as context (gitignored)
├── reports/           # timestamped phase reports
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

- Paper: .autoresearch/paper/
- Phases: ground, specify, experiment, judge
- Notes: (none)
```

Three settings, that's it:
- **Paper** — path to the paper directory (auto-detected on setup)
- **Phases** — which phases to run, in order
- **Notes** — freeform (stack, hardware, constraints, conventions)

## Phases

Four phases. Read the detailed protocol from `${CLAUDE_SKILL_DIR}/phases/<phase>.md` before executing each one.

| Phase | What happens | Pauses for user? |
|-------|-------------|-----------------|
| **ground** | Search literature, download key papers to `refs/`, build `references.bib` | Yes — user confirms gap and direction |
| **specify** | Co-write abstract + intro, citing `references.bib` | Yes — user approves spec |
| **experiment** | Run experiments in `scratch/`, log results to `log.jsonl` | No — runs autonomously |
| **judge** | Evaluate results against paper claims, decide next action | Only if verdict is PIVOT |

Experiment → judge loops until the judge passes.

## References

`references.bib` in the paper directory is maintained across all phases. Rules:
1. Every claim in the main `.tex` file must have a `\cite{}`
2. Never fabricate — if you can't verify, add `note = {TO VERIFY}`
3. Cite keys: `{firstauthor}{year}{keyword}` (e.g., `vaswani2017attention`)
4. When you find a key paper, download its arxiv HTML to `.autoresearch/refs/` for full-text context

## Reports

After completing each phase, write a report to `.autoresearch/reports/YYYY-MM-DD-<phase>.md`. If multiple runs on the same day, append a number: `2026-03-11-experiment-2.md`.

Reports should be concise, human-readable summaries:
- **What was done** — actions taken, decisions made
- **Key findings** — results, discoveries, surprises
- **Next steps** — what the next phase should focus on

These are for the user to review progress without reading `log.jsonl`.

## Activity Log

Append to `.autoresearch/log.jsonl` after every significant action:
```json
{"time":"ISO-8601","phase":"ground","action":"searched sparse attention papers","result":"found 12 relevant papers","refs_added":["child2019sparse"]}
```

Read the log before acting to avoid repeating work.

## Execution

### First run (`/autoresearch "question"`):
1. Create `.autoresearch/` structure
2. **Auto-detect paper directory**: Search for existing `.tex` files in `paper/`, `./`, `.autoresearch/paper/`. If found, set `Paper:` in settings.md to that directory. If not found, create `.autoresearch/paper/` with template from `${CLAUDE_SKILL_DIR}/templates/paper.tex` and an empty `references.bib`.
3. Create default `settings.md` (with detected paper path), ask user to review
4. Read `${CLAUDE_SKILL_DIR}/phases/ground.md` — **execute it now**

### Resume (`/autoresearch resume`):
1. Read `.autoresearch/log.jsonl` to find current state
2. Read the next phase protocol — **execute it now**

### Skip (`/autoresearch skip ground`):
1. Skip that phase, proceed to next
