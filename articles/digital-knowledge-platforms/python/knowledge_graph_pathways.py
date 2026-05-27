"""
Knowledge graph and conceptual pathway example.

This lightweight script reads synthetic concept and relationship data,
then creates a simple degree summary without external dependencies.
"""

from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(exist_ok=True)

concepts_path = DATA / "concepts.csv"
relationships_path = DATA / "relationships.csv"

with concepts_path.open(newline="", encoding="utf-8") as f:
    concepts = list(csv.DictReader(f))

with relationships_path.open(newline="", encoding="utf-8") as f:
    relationships = list(csv.DictReader(f))

degree = {row["label"]: 0 for row in concepts}

for row in relationships:
    degree[row["source"]] = degree.get(row["source"], 0) + 1
    degree[row["target"]] = degree.get(row["target"], 0) + 1

out_path = OUTPUTS / "concept_degree_summary.csv"

with out_path.open("w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["concept", "degree"])
    for concept, value in sorted(degree.items()):
        writer.writerow([concept, value])

print(f"Wrote {out_path}")
