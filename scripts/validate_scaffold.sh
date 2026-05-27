#!/usr/bin/env bash
set -euo pipefail

missing=0

for d in articles docs data governance ontology taxonomy schemas scripts tests; do
  if [ ! -d "$d" ]; then
    echo "Missing root directory: $d"
    missing=1
  fi
done

article_count=$(find articles -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
echo "Article folder count: $article_count"

if [ "$article_count" -lt 26 ]; then
  echo "Expected at least 26 article folders."
  missing=1
fi

if [ "$missing" -eq 0 ]; then
  echo "Scaffold validation passed."
else
  echo "Scaffold validation failed."
  exit 1
fi
