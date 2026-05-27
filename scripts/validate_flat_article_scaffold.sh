#!/usr/bin/env bash
set -euo pipefail

expected=(python r julia sql rust go cpp fortran c docs data outputs)
missing=0

for article in articles/*; do
  [ -d "$article" ] || continue

  for subdir in "${expected[@]}"; do
    if [ ! -d "$article/$subdir" ]; then
      echo "Missing $article/$subdir"
      missing=1
    fi
  done
done

count=$(find articles -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
echo "Article folders: $count"

if [ "$missing" -eq 0 ]; then
  echo "Flat article scaffold validation passed."
else
  echo "Flat article scaffold validation failed."
  exit 1
fi
