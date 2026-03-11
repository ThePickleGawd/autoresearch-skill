# autoresearch

Paper-first autonomous research agent. An [Agent Skill](https://agentskills.io) that works with Claude Code, Codex, Cursor, and any skills-compatible agent.

## What it does

Unlike traditional approaches (run experiments → write paper), autoresearch **writes the paper first**. The abstract and introduction become the specification. Experiments validate claims. A judge loop iterates until results pass.

**Inspired by:** [karpathy/autoresearch](https://github.com/karpathy/autoresearch), [GEA](https://arxiv.org/abs/2602.04837) (interagent communication via shared experience pools), [AI-Scientist-v2](https://github.com/SakanaAI/AI-Scientist-v2), [AgentRxiv](https://agentrxiv.github.io/)

## Install

```bash
# Claude Code
npx skills add dylan/autoresearch

# Or symlink for local dev
ln -s /path/to/autoresearch ~/.claude/skills/autoresearch

# Codex — copy SKILL.md content into AGENTS.md (frontmatter is ignored gracefully)
```

## Usage

```
/autoresearch "Can sparse attention match dense attention quality at 1/4 the compute?"
```

## How it works

### Six phases

| Phase | Name | What happens |
|-------|------|-------------|
| 1 | **Ground** | Survey literature, build `references.bib`, identify the gap |
| 2 | **Specify** | Co-write abstract + intro with user, citing previous works |
| 3 | **Scaffold** | Set up experiment code, data pipelines, evaluation harness |
| 4 | **Experiment** | Run validation experiments, log to shared pool |
| 5 | **Judge** | Evaluate results against paper claims (adversarial) |
| 6 | **Branch** | Spawn parallel agents for new directions (GEA-style) |

Phases 4→5→6 loop until the judge passes.

### Key ideas

- **Paper as specification** — The `.tex` file defines what must be true. Experiments fill claims.
- **Shared experience pool** — All agents read/write `shared_pool/`. Innovations propagate across branches ([GEA architecture](https://arxiv.org/abs/2602.04837)).
- **Judge loop** — No result accepted without adversarial evaluation. 5 criteria scored 0.0-1.0.
- **Living references** — `references.bib` maintained continuously. Every claim must cite. Never fabricate.
- **Parallel branching** — When findings suggest new directions, spawn subagents that share the experience pool.

### Project structure (generated)

```
your-project/
├── paper/
│   ├── paper.tex              # The spec — written FIRST
│   └── references.bib         # Living bibliography
├── experiments/
│   ├── baseline/              # Validation experiments
│   └── branch_NNN/            # Parallel branches
├── shared_pool/
│   ├── experience_log.jsonl   # All agent traces (GEA pool)
│   ├── findings.md            # Consolidated discoveries
│   └── literature_notes.md    # Paper summaries
├── judge/
│   └── evaluations.jsonl      # Verdicts with reasoning
└── research_state.json        # Phase tracking
```

## Skill structure

```
autoresearch/
├── SKILL.md              # Main entry point
├── phases/
│   ├── 01-ground.md      # Literature survey protocol
│   ├── 02-specify.md     # Abstract + intro writing
│   ├── 03-scaffold.md    # Experiment setup
│   ├── 04-experiment.md  # Run & iterate
│   ├── 05-judge.md       # Adversarial evaluation
│   └── 06-branch.md      # Parallel exploration (GEA)
├── templates/
│   ├── paper.tex         # LaTeX template
│   ├── experience_entry.json  # Shared pool schema
│   └── judge_rubric.md   # Scoring guide
└── scripts/
    └── init_project.sh   # Project scaffolding
```

## License

MIT
