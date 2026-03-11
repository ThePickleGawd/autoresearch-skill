# autoresearch

Paper-first autonomous research. An [Agent Skill](https://agentskills.io) for Claude Code, Codex, Cursor, and any compatible agent.

Writes the paper first. Experiments validate claims. A judge loop iterates until results pass.

**Inspired by:** [karpathy/autoresearch](https://github.com/karpathy/autoresearch), [GEA](https://arxiv.org/abs/2602.04837), [AI-Scientist-v2](https://github.com/SakanaAI/AI-Scientist-v2), [AgentRxiv](https://agentrxiv.github.io/)

## Install

```bash
npx skills add ThePickleGawd/autoresearch-skill
```

## Usage

```
/autoresearch "Can sparse attention match dense attention at 1/4 the compute?"
/autoresearch resume
```

## What it creates

Everything lives in `.autoresearch/` in your project:

```
.autoresearch/
├── paper/             # paper directory (default, or your conference zip)
│   ├── main.tex       # auto-detected main file
│   └── references.bib # living bibliography
├── refs/              # downloaded arxiv papers (gitignored)
├── reports/           # timestamped phase reports
├── settings.md        # project preferences
├── log.jsonl          # all activity
└── scratch/           # experiment work (gitignored)
```

**Using a conference template?** Download the zip (NeurIPS, COLM, etc.), extract to `paper/` or `.autoresearch/paper/`, and autoresearch will auto-detect it.

## Settings

`.autoresearch/settings.md` — auto-generated on first run:

```markdown
# Research Settings
- Paper: .autoresearch/paper/
- Phases: ground, specify, experiment, judge
- Notes: python + jax, single GPU, use wandb
```

## Four phases

| Phase | What | Pauses? |
|-------|------|---------|
| **ground** | Search literature, download papers, build references.bib | Yes |
| **specify** | Co-write abstract + intro as the spec | Yes |
| **experiment** | Run experiments in scratch/, log results | No |
| **judge** | Evaluate results, decide pass/revise/pivot | If pivot |

Experiment → judge loops until pass.

## License

MIT
