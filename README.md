```
 █████╗ ██╗   ██╗████████╗ ██████╗
██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗
███████║██║   ██║   ██║   ██║   ██║
██╔══██║██║   ██║   ██║   ██║   ██║
██║  ██║╚██████╔╝   ██║   ╚██████╔╝
╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝
██████╗ ███████╗███████╗███████╗ █████╗ ██████╗  ██████╗██╗  ██╗
██╔══██╗██╔════╝██╔════╝██╔════╝██╔══██╗██╔══██╗██╔════╝██║  ██║
██████╔╝█████╗  ███████╗█████╗  ███████║██████╔╝██║     ███████║
██╔══██╗██╔══╝  ╚════██║██╔══╝  ██╔══██║██╔══██╗██║     ██╔══██║
██║  ██║███████╗███████║███████╗██║  ██║██║  ██║╚██████╗██║  ██║
╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
```

**Write the paper before you run a single experiment.** Your abstract is the spec. Your claims are the targets. An agent grounds you in literature, runs the experiments, and judges the results — looping until the evidence is convincing.

An [Agent Skill](https://agentskills.io) for Claude Code, Codex, Cursor, and any compatible agent.

## Install

```bash
npx skills add ThePickleGawd/autoresearch-skill
```

## Usage

```
/autoresearch "Can sparse attention match dense attention at 1/4 the compute?"
/autoresearch resume
```

## How it works

Most research tools start with code and optimize metrics. **Autoresearch starts with the paper.**

Your abstract and introduction are the specification — every claim becomes a validation target. The agent then runs experiments to prove or disprove those claims, with an adversarial judge that loops until the evidence is convincing.

```
 Question → Ground → Specify → Experiment ⇄ Judge → Done
              │         │          │            │
          literature  abstract   run code    pass/revise/
           survey    + intro =   validate     pivot
                     the spec    claims
```

### Key design choices

- **The paper comes first.** You write the abstract and intro before any code runs. Claims drive experiments, not the other way around.
- **One folder, self-contained.** Paper, references, reports, logs — everything lives in `.autoresearch/`.
- **Drop in your conference template.** Download a NeurIPS or COLM zip, extract it, and it just works.
- **`uv` by default.** Fast package management out of the box. Configurable to pip or conda.
- **Reports you'll actually read.** Every phase writes a short report tied to your research question — not just a raw log.
- **Two commands.** Start and resume. That's it.

## What it creates

```
.autoresearch/
├── paper/             # your paper (default template or conference zip)
│   ├── main.tex
│   └── references.bib
├── refs/              # downloaded arxiv papers for context
├── reports/           # timestamped phase reports
├── settings.md        # auto-detected project preferences
├── log.jsonl          # full activity log
└── scratch/           # throwaway experiment outputs
third_party/           # cloned external repos
```

## Settings

`.autoresearch/settings.md` — auto-generated on first run. The agent scans your repo and asks you to confirm:

```markdown
# Research Settings
- Paper: .autoresearch/paper/
- Env: uv, python 3.11, cuda 12.1
- Phases: ground, specify, experiment, judge
- Notes: single GPU, use jax
```

## Phases

| | Phase | What happens | Pauses? |
|-|-------|-------------|---------|
| 1 | **Ground** | Search literature, download papers, build `references.bib` | Yes |
| 2 | **Specify** | Co-write abstract + intro as the spec, extract validation targets | Yes |
| 3 | **Experiment** | Run experiments, validate claims with real results | No |
| 4 | **Judge** | Adversarial evaluation — pass, revise, or pivot | If pivot |

Experiment → Judge loops until pass (max 3 before asking you).

## Inspired by

[karpathy/autoresearch](https://github.com/karpathy/autoresearch) · [GEA](https://arxiv.org/abs/2602.04837) · [AI-Scientist-v2](https://github.com/SakanaAI/AI-Scientist-v2) · [AgentRxiv](https://agentrxiv.github.io/)

## License

MIT
