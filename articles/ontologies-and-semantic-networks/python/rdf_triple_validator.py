#!/usr/bin/env python3
"""
Validate lightweight RDF-style triples for the article folder.
"""

from pathlib import Path
import csv
import sys

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(exist_ok=True)

required = {"subject", "predicate", "object"}
triples_path = DATA / "triples.csv"

with triples_path.open(newline="", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    missing = required - set(reader.fieldnames or [])
    if missing:
        print(f"Missing required columns: {sorted(missing)}", file=sys.stderr)
        sys.exit(1)
    rows = list(reader)

issues = []
for idx, row in enumerate(rows, start=2):
    for field in required:
        if not row.get(field, "").strip():
            issues.append({"line": idx, "field": field, "issue": "blank required field"})

with (OUTPUTS / "rdf_triple_validation_report.csv").open("w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=["line", "field", "issue"])
    writer.writeheader()
    writer.writerows(issues)

if issues:
    print(f"Validation found {len(issues)} issue(s).")
    sys.exit(1)

print(f"Validated {len(rows)} triples with no required-field issues.")
