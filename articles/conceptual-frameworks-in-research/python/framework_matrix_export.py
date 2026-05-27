#!/usr/bin/env python3
"""
Export a conceptual framework adjacency matrix.
"""

from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(exist_ok=True)

with (DATA / "framework_concepts.csv").open(newline="", encoding="utf-8") as f:
    concepts = list(csv.DictReader(f))

with (DATA / "framework_relationships.csv").open(newline="", encoding="utf-8") as f:
    relationships = list(csv.DictReader(f))

ids = [row["concept_id"] for row in concepts]
labels = {row["concept_id"]: row["label"] for row in concepts}
matrix = {source: {target: 0 for target in ids} for source in ids}

for row in relationships:
    matrix[row["source_concept_id"]][row["target_concept_id"]] = 1

out_path = OUTPUTS / "framework_adjacency_matrix.csv"

with out_path.open("w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["concept"] + [labels[concept_id] for concept_id in ids])
    for source in ids:
        writer.writerow([labels[source]] + [matrix[source][target] for target in ids])

print(f"Wrote {out_path}")
