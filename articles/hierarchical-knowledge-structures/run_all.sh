#!/usr/bin/env bash
set -euo pipefail

echo "Running Hierarchical Knowledge Structures workflows..."

if command -v python3 >/dev/null 2>&1; then
  python3 python/hierarchy_audit.py
else
  echo "python3 not found; skipping Python workflow."
fi

if command -v Rscript >/dev/null 2>&1; then
  Rscript r/hierarchy_diagnostics.R
else
  echo "Rscript not found; skipping R workflow."
fi

if command -v julia >/dev/null 2>&1; then
  julia julia/hierarchy_metrics.jl
else
  echo "julia not found; skipping Julia workflow."
fi

echo "Done."
