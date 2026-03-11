#!/bin/bash
# Initialize an autoresearch project structure
# Usage: ./init_project.sh "Research question here"

set -e

RESEARCH_QUESTION="${1:-Untitled Research}"
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_DIR="$(pwd)"

echo "Initializing autoresearch project..."
echo "Question: $RESEARCH_QUESTION"
echo "Directory: $PROJECT_DIR"

# Create directory structure
mkdir -p paper
mkdir -p experiments/baseline
mkdir -p shared_pool
mkdir -p judge

# Copy paper template
cp "$SKILL_DIR/templates/paper.tex" paper/paper.tex

# Initialize references.bib
cat > paper/references.bib << 'BIBEOF'
% Autoresearch bibliography
% Maintained continuously across all phases.
% Format: @type{firstauthorYEARkeyword, ...}
% Keep sorted alphabetically by cite key.

BIBEOF

# Initialize experience log
touch shared_pool/experience_log.jsonl

# Initialize findings
cat > shared_pool/findings.md << 'EOF'
# Research Findings

This document is updated continuously by all agents.
Each phase appends its findings below.

---

EOF

# Initialize literature notes
cat > shared_pool/literature_notes.md << 'EOF'
# Literature Notes

Populated during Phase 1 (Ground).

---

EOF

# Initialize research state
cat > research_state.json << STATEEOF
{
  "research_question": "$RESEARCH_QUESTION",
  "phase": 1,
  "created": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "validation_targets": [],
  "branches": [],
  "judge_iterations": 0
}
STATEEOF

# Initialize git if not already
if [ ! -d .git ]; then
  git init
  cat > .gitignore << 'GIEOF'
# Autoresearch
*.aux
*.log
*.out
*.bbl
*.blg
*.fls
*.fdb_latexmk
*.synctex.gz
__pycache__/
*.pyc
.venv/
data/raw/
*.pt
*.pth
*.ckpt
GIEOF
  echo "Initialized git repository"
fi

echo ""
echo "Project initialized. Structure:"
find . -not -path './.git/*' -not -path './.git' | head -30
echo ""
echo "Next: Begin Phase 1 (Ground) — literature survey"
