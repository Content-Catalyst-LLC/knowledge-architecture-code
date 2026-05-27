#!/usr/bin/env bash
set -euo pipefail

expected=(python r julia sql rust go cpp fortran c docs data outputs)
missing=0

for article in articles/*; do
  [ -d "$article" ] || continue
  for subdir in "${expected[@]}"; do
    if [ ! -d "$article/$subdir" ]; then
      echo "Missing: $article/$subdir"
      missing=1
    fi
  done
done

count=$(find articles -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
echo "Article folders: $count"

if [ "$count" -ne 26 ]; then
  echo "Expected 26 article folders."
  missing=1
fi

if [ "$missing" -eq 0 ]; then
  echo "Compact scaffold validation passed."
else
  echo "Compact scaffold validation failed."
  exit 1
fi
