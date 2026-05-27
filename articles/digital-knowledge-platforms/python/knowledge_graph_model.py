"""
Synthetic knowledge-graph workflow for a Knowledge Architecture article.
"""

from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parents[1]
concepts_path = ROOT / "data" / "synthetic" / "concepts.csv"
relationships_path = ROOT / "data" / "synthetic" / "relationships.csv"
outputs_dir = ROOT / "outputs" / "tables"
outputs_dir.mkdir(parents=True, exist_ok=True)

with concepts_path.open(newline="", encoding="utf-8") as f:
    concepts = list(csv.DictReader(f))

with relationships_path.open(newline="", encoding="utf-8") as f:
    relationships = list(csv.DictReader(f))

degree = {row["label"]: 0 for row in concepts}

for row in relationships:
    degree[row["source"]] = degree.get(row["source"], 0) + 1
    degree[row["target"]] = degree.get(row["target"], 0) + 1

out_path = outputs_dir / "concept_degree_summary.csv"

with out_path.open("w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["concept", "degree"])
    for concept, value in sorted(degree.items()):
        writer.writerow([concept, value])

print(f"Wrote {out_path}")
