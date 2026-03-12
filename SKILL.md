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
├── paper/             # paper directory
│   ├── paper.md       # default (or main.tex if LaTeX)
│   └── references.bib # living bibliography
├── state.md           # current snapshot (rewritten, not appended)
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
1. Every claim must be cited — use `[@citekey]` in markdown or `\cite{citekey}` in LaTeX
2. Never fabricate — if you can't verify, add `note = {TO VERIFY}` to the bib entry
3. Cite keys: `{firstauthor}{year}{keyword}` (e.g., `vaswani2017attention`)
4. When you find a key paper, download its arxiv HTML to `.autoresearch/refs/` for full-text context

## Reports

After completing each phase, write a report to `.autoresearch/reports/YYYY-MM-DD/<phase>/report.md`. For phases that loop (experiment, judge), number subsequent reports: `report_2.md`, `report_3.md`. Additional artifacts (figures, data, tables) go in the same folder.

Reports are grounded in the research intention — always tie back to what the user set out to show:
- **Research intent** — restate the question/hypothesis being pursued
- **Evidence** — what the data shows, with specific numbers
- **Assessment** — does this support or contradict the claims? Why?
- **Gaps** — what remains unresolved or uncertain

These are for the user to quickly judge whether the research is on track.

## State

`.autoresearch/state.md` is the working memory. **Rewrite it (don't append)** after every phase completion or significant change. It should always reflect current reality:

- **Status** — current phase, attempt number, last updated
- **Validation targets** — each claim and whether it's passed, in progress, or failed
- **Best results** — key metrics from experiments so far
- **Key findings** — insights discovered along the way
- **Dead ends** — what didn't work and why
- **Preferences** — user preferences learned during the session

Read `state.md` first when resuming. It's faster than parsing the full log.

## Activity Log

Append to `.autoresearch/log.jsonl` after every significant action:
```json
{"time":"ISO-8601","phase":"ground","action":"searched sparse attention papers","result":"found 12 relevant papers","refs_added":["child2019sparse"]}
```

Read the log before acting to avoid repeating work.

## Git

Commit at phase boundaries. Prefix with `[autoresearch]` so research history is easy to filter (`git log --grep="autoresearch"`).

When to commit:
- After setup: `[autoresearch] setup — <topic>`
- After ground: `[autoresearch] ground — <gap found, key insight>`
- After specify: `[autoresearch] specify — <main claim, N targets>`
- After judge: `[autoresearch] judge — <verdict, why>`
- After meaningful experiment results: `[autoresearch] experiment — <what changed, result>`

Don't commit every failed experiment attempt — `log.jsonl` and `state.md` track that.

## Execution

### First run (`/autoresearch "question"`):

**Step 1: Scan the repo.** Before asking anything, silently survey the project:
- Glob for `**/*.tex`, `**/*.bib`, `**/paper/`, `**/*.sty`, `**/*.cls`
- Glob for `**/*.py`, `**/*.ipynb`, `**/requirements.txt`, `**/pyproject.toml`
- Check for existing `.autoresearch/`
- Read `README.md`, `CLAUDE.md`, `AGENTS.md` if they exist

**Step 2: Ask setup questions.** Based on what you found, ask the user (all at once, not one by one):
- **Paper format**: Found `.tex` files → "Use this as the working paper?" / Nothing found → "Write in markdown (recommended) or import a LaTeX project (e.g., NeurIPS/COLM zip)?"
- **Existing code**: Found Python files → "Should experiments build on this codebase?" / Nothing → "What stack? (e.g., python + jax, pytorch)"
- **Environment**: Detect `uv.lock`, `requirements.txt`, `pyproject.toml`, `environment.yml`, `Dockerfile` → confirm. Nothing found → "What tools? (uv recommended, python version, cuda, docker, etc.)"
- **Any other preferences**: hardware, compute constraints, specific baselines to include

**Step 3: Set up.** Based on answers:
1. Create `.autoresearch/` structure (refs/, reports/, scratch/, log.jsonl)
2. Set up paper directory — if markdown: create `paper.md` from `${CLAUDE_SKILL_DIR}/templates/paper.md` + empty `references.bib`. If LaTeX: use detected template or tell user to extract their conference zip into the paper directory.
3. Write `settings.md` with all detected/confirmed values
4. Add `.autoresearch/refs/` and `.autoresearch/scratch/` to `.gitignore`
5. Add a section to `CLAUDE.md` (create if needed):
   ```
   ## Research
   This project uses [autoresearch](https://github.com/ThePickleGawd/autoresearch-skill).
   Current status: `.autoresearch/state.md`
   Run `/autoresearch resume` to continue.
   ```

**Step 4: Begin ground phase.** Read `${CLAUDE_SKILL_DIR}/phases/ground.md` — **execute it now.**

### Resume (`/autoresearch resume`):
1. Read `.autoresearch/state.md` — this tells you where things stand
2. Read `.autoresearch/settings.md` for project config
3. Read the next phase protocol — **execute it now**
