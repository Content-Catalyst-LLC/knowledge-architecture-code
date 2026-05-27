#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "Running local checks for conceptual-frameworks-in-research..."

python3 python/framework_network_analysis.py
python3 python/framework_matrix_export.py

if command -v Rscript >/dev/null 2>&1; then
  Rscript r/framework_coverage_audit.R
else
  echo "Rscript not found; skipping R audit."
fi

if command -v julia >/dev/null 2>&1; then
  julia julia/framework_pathways.jl
else
  echo "Julia not found; skipping Julia scaffold."
fi

echo "Local checks completed."
