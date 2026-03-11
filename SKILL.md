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
- Env: uv, python 3.11
- Phases: ground, specify, experiment, judge
- Notes: (none)
```

Four settings, that's it:
- **Paper** — path to the paper directory (auto-detected on setup)
- **Env** — tooling and environment (e.g., `uv, python 3.11`, `conda, cuda 12.1`, `pip, docker`)
- **Phases** — which phases to run, in order
- **Notes** — freeform (hardware, constraints, conventions)

## Phases

Four phases. Read the detailed protocol from `${CLAUDE_SKILL_DIR}/phases/<phase>.md` before executing each one.

| Phase | What happens | Pauses for user? |
|-------|-------------|-----------------|
| **ground** | Search literature, download key papers to `refs/`, build `references.bib` | Yes — user confirms gap and direction |
| **specify** | Co-write abstract + intro, citing `references.bib` | Yes — user approves spec |
| **experiment** | Run experiments (code in repo, outputs in `scratch/`), log to `log.jsonl` | No — runs autonomously |
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

Reports are grounded in the research intention — always tie back to what the user set out to show:
- **Research intent** — restate the question/hypothesis being pursued
- **Evidence** — what the data shows, with specific numbers
- **Assessment** — does this support or contradict the claims? Why?
- **Gaps** — what remains unresolved or uncertain

These are for the user to quickly judge whether the research is on track.

## Activity Log

Append to `.autoresearch/log.jsonl` after every significant action:
```json
{"time":"ISO-8601","phase":"ground","action":"searched sparse attention papers","result":"found 12 relevant papers","refs_added":["child2019sparse"]}
```

Read the log before acting to avoid repeating work.

## Execution

### First run (`/autoresearch "question"`):

**Step 1: Scan the repo.** Before asking anything, silently survey the project:
- Glob for `**/*.tex`, `**/*.bib`, `**/paper/`, `**/*.sty`, `**/*.cls`
- Glob for `**/*.py`, `**/*.ipynb`, `**/requirements.txt`, `**/pyproject.toml`
- Check for existing `.autoresearch/`
- Read `README.md`, `CLAUDE.md`, `AGENTS.md` if they exist

**Step 2: Ask setup questions.** Based on what you found, ask the user (all at once, not one by one):
- **Paper**: Found `paper/main.tex` → "Use this as the working paper?" / Nothing found → "Start from scratch or import a conference template?"
- **Existing code**: Found Python files → "Should experiments build on this codebase?" / Nothing → "What stack? (e.g., python + jax, pytorch)"
- **Environment**: Detect `uv.lock`, `requirements.txt`, `pyproject.toml`, `environment.yml`, `Dockerfile` → confirm. Nothing found → "What tools? (uv recommended, python version, cuda, docker, etc.)"
- **Any other preferences**: hardware, compute constraints, specific baselines to include

**Step 3: Set up.** Based on answers:
1. Create `.autoresearch/` structure (refs/, reports/, scratch/, log.jsonl)
2. Set up paper directory — use detected template, create from `${CLAUDE_SKILL_DIR}/templates/paper.tex`, or note that user will import one
3. Write `settings.md` with all detected/confirmed values
4. Add `.autoresearch/refs/` and `.autoresearch/scratch/` to `.gitignore`

**Step 4: Begin ground phase.** Read `${CLAUDE_SKILL_DIR}/phases/ground.md` — **execute it now.**

### Resume (`/autoresearch resume`):
1. Read `.autoresearch/log.jsonl` to find current state
2. Read the next phase protocol — **execute it now**
