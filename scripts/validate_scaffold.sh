#!/usr/bin/env bash
set -euo pipefail

required_dirs=(
  "articles"
  "docs"
  "schemas"
  "taxonomy"
  "ontology"
  "governance"
)

for dir in "${required_dirs[@]}"; do
  if [ ! -d "$dir" ]; then
    echo "Missing required directory: $dir"
    exit 1
  fi
done

article_count=$(find articles -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
echo "Article folder count: $article_count"

if [ "$article_count" -lt 26 ]; then
  echo "Expected at least 26 article folders."
  exit 1
fi

echo "Scaffold validation passed."
