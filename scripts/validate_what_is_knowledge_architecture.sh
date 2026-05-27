#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="articles/what-is-knowledge-architecture"

required=(
  "python"
  "r"
  "julia"
  "sql"
  "rust"
  "go"
  "cpp"
  "fortran"
  "c"
  "docs"
  "data"
  "outputs"
)

for d in "${required[@]}"; do
  if [ ! -d "${ARTICLE_DIR}/${d}" ]; then
    echo "Missing ${ARTICLE_DIR}/${d}"
    exit 1
  fi
done

for f in \
  "${ARTICLE_DIR}/README.md" \
  "${ARTICLE_DIR}/data/concepts.csv" \
  "${ARTICLE_DIR}/data/relationships.csv" \
  "${ARTICLE_DIR}/python/knowledge_architecture_graph.py" \
  "${ARTICLE_DIR}/r/taxonomy_balance_audit.R" \
  "${ARTICLE_DIR}/sql/schema.sql" \
  "${ARTICLE_DIR}/docs/github-embed-wordpress.html"
do
  if [ ! -f "$f" ]; then
    echo "Missing file: $f"
    exit 1
  fi
done

echo "What Is Knowledge Architecture scaffold validation passed."
