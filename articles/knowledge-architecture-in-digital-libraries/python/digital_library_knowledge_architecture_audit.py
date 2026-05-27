#!/usr/bin/env python3
from __future__ import annotations

import csv
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(exist_ok=True)

def read_csv(path: Path):
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))

def write_csv(path: Path, rows, fieldnames):
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)

def truthy(value: str) -> bool:
    return value.strip().lower() in {"true", "1", "yes", "y"}

objects = read_csv(DATA / "digital_objects.csv")
relationships = read_csv(DATA / "digital_library_relationships.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0

for rel in relationships:
    degree[rel["source_object_id"]] += 1
    degree[rel["target_object_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1

object_rows = []
for obj in objects:
    object_id = obj["object_id"]
    row = {
        "object_id": object_id,
        "title": obj["title"],
        "object_type": obj["object_type"],
        "has_metadata": truthy(obj["has_metadata"]),
        "has_subject": truthy(obj["has_subject"]),
        "has_rights": truthy(obj["has_rights"]),
        "has_preservation": truthy(obj["has_preservation"]),
        "status": obj["status"],
        "relationship_degree": degree[object_id],
        "is_orphan": degree[object_id] == 0,
    }
    row["needs_review"] = (
        not row["has_metadata"]
        or not row["has_rights"]
        or row["status"] == "review_needed"
        or row["is_orphan"]
    )
    object_rows.append(row)

write_csv(
    OUTPUTS / "digital_library_object_diagnostics.csv",
    object_rows,
    ["object_id", "title", "object_type", "has_metadata", "has_subject", "has_rights", "has_preservation", "status", "relationship_degree", "is_orphan", "needs_review"],
)

write_csv(
    OUTPUTS / "digital_library_relationship_type_summary.csv",
    [{"relationship_type": k, "count": v} for k, v in relationship_types.items()],
    ["relationship_type", "count"],
)

summary = {
    "object_count": len(objects),
    "relationship_count": len(relationships),
    "metadata_coverage": round(sum(r["has_metadata"] for r in object_rows) / len(objects), 3),
    "subject_coverage": round(sum(r["has_subject"] for r in object_rows) / len(objects), 3),
    "rights_coverage": round(sum(r["has_rights"] for r in object_rows) / len(objects), 3),
    "preservation_coverage": round(sum(r["has_preservation"] for r in object_rows) / len(objects), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "orphan_count": sum(r["is_orphan"] for r in object_rows),
    "review_needed_count": sum(r["needs_review"] for r in object_rows),
    "relationship_type_count": len(relationship_types),
}

with (OUTPUTS / "digital_library_knowledge_architecture_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote digital library knowledge architecture diagnostics to:", OUTPUTS)
