#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Running Python example..."
python3 python/knowledge_architecture_graph.py

if command -v Rscript >/dev/null 2>&1; then
  echo "Running R example..."
  Rscript r/taxonomy_balance_audit.R
else
  echo "Skipping R example because Rscript was not found."
fi

if command -v julia >/dev/null 2>&1; then
  echo "Running Julia example..."
  julia julia/semantic_network_metrics.jl
else
  echo "Skipping Julia example because julia was not found."
fi

echo "Done."
