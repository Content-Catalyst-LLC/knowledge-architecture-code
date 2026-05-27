#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../articles/foundations-of-knowledge-architecture" && pwd)"
cd "$ARTICLE_DIR"

echo "Running Foundations of Knowledge Architecture examples..."

if command -v python3 >/dev/null 2>&1; then
  echo "Python available. Install dependencies first if needed: python3 -m pip install -r python/requirements.txt"
fi

if command -v Rscript >/dev/null 2>&1; then
  Rscript r/taxonomy_coherence_analysis.R
fi

if command -v julia >/dev/null 2>&1; then
  julia julia/semantic_network_matrix.jl
fi

echo "Example runner complete."
