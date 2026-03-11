# autoresearch

Paper-first autonomous research. An [Agent Skill](https://agentskills.io) for Claude Code, Codex, Cursor, and any compatible agent.

Writes the paper first. Experiments validate claims. A judge loop iterates until results pass.

**Inspired by:** [karpathy/autoresearch](https://github.com/karpathy/autoresearch), [GEA](https://arxiv.org/abs/2602.04837), [AI-Scientist-v2](https://github.com/SakanaAI/AI-Scientist-v2), [AgentRxiv](https://agentrxiv.github.io/)

## Install

```bash
npx skills add dylan/autoresearch
```

## Usage

```
/autoresearch "Can sparse attention match dense attention at 1/4 the compute?"
/autoresearch resume
/autoresearch skip ground
```

## What it creates

Everything lives in `.autoresearch/` in your project:

```
.autoresearch/
├── paper.tex          # working paper (written first)
├── references.bib     # living bibliography
├── refs/              # downloaded arxiv papers (gitignored)
├── settings.md        # project preferences
├── log.jsonl          # all activity
└── scratch/           # experiment work (gitignored)
```

## Settings

`.autoresearch/settings.md` — three options, all optional:

```markdown
# Research Settings
- Format: latex
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
