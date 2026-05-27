#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Running Python ontology and semantic-network audit..."
python3 python/semantic_network_ontology_audit.py

echo "Running RDF-style triple validator..."
python3 python/rdf_triple_validator.py

if command -v Rscript >/dev/null 2>&1; then
  echo "Running R semantic-network diagnostics..."
  Rscript r/semantic_network_diagnostics.R
else
  echo "Rscript not found; skipping R diagnostics."
fi

echo "Diagnostics complete. See outputs/."
