#!/usr/bin/env bash
set -euo pipefail

ARTICLE_DIR="articles/hierarchical-knowledge-structures"

expected_dirs=(
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

for dir in "${expected_dirs[@]}"; do
  if [ ! -d "$ARTICLE_DIR/$dir" ]; then
    echo "Missing: $ARTICLE_DIR/$dir"
    exit 1
  fi
done

required_files=(
  "$ARTICLE_DIR/README.md"
  "$ARTICLE_DIR/data/hierarchy_nodes.csv"
  "$ARTICLE_DIR/data/hierarchy_edges.csv"
  "$ARTICLE_DIR/python/hierarchy_audit.py"
  "$ARTICLE_DIR/r/hierarchy_diagnostics.R"
  "$ARTICLE_DIR/julia/hierarchy_metrics.jl"
  "$ARTICLE_DIR/sql/hierarchical_knowledge_structure_schema.sql"
  "$ARTICLE_DIR/docs/github-embed-wordpress.html"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required file: $file"
    exit 1
  fi
done

echo "Hierarchical Knowledge Structures scaffold validation passed."
