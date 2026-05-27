#!/usr/bin/env python3
"""
Sustainability Knowledge Architecture Audit

Audits a synthetic sustainability-science knowledge model for:
- metadata coverage
- justice context coverage
- uncertainty context coverage
- scale distribution
- relationship traceability
- underspecified relationship risk
- review needs
"""

from __future__ import annotations

import csv
from collections import Counter, defaultdict
from pathlib import Path
from typing import Dict, Iterable, List


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(exist_ok=True)


def read_csv(path: Path) -> List[Dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: Iterable[Dict[str, object]], fieldnames: List[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def truthy(value: str) -> bool:
    return value.strip().lower() in {"true", "1", "yes", "y"}


objects = read_csv(DATA / "sustainability_objects.csv")
relationships = read_csv(DATA / "sustainability_relationships.csv")
systems = read_csv(DATA / "systems.csv")
concepts = read_csv(DATA / "concepts.csv")
evidence_types = read_csv(DATA / "evidence_types.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0
underspecified = 0

for rel in relationships:
    degree[rel["source_object_id"]] += 1
    degree[rel["target_object_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1
    if rel["relationship_type"] in {"related", "sameAs", ""}:
        underspecified += 1

object_rows = []
for obj in objects:
    object_id = obj["object_id"]
    has_metadata = truthy(obj["has_metadata"])
    has_justice_context = truthy(obj["has_justice_context"])
    has_uncertainty_context = truthy(obj["has_uncertainty_context"])
    is_orphan = degree[object_id] == 0
    needs_review = (
        not has_metadata
        or obj["status"] == "review_needed"
        or is_orphan
    )
    object_rows.append(
        {
            "object_id": object_id,
            "title": obj["title"],
            "object_type": obj["object_type"],
            "has_metadata": has_metadata,
            "scale": obj["scale"],
            "has_justice_context": has_justice_context,
            "has_uncertainty_context": has_uncertainty_context,
            "status": obj["status"],
            "relationship_degree": degree[object_id],
            "is_orphan": is_orphan,
            "needs_review": needs_review,
        }
    )

write_csv(
    OUTPUTS / "sustainability_object_diagnostics.csv",
    object_rows,
    [
        "object_id",
        "title",
        "object_type",
        "has_metadata",
        "scale",
        "has_justice_context",
        "has_uncertainty_context",
        "status",
        "relationship_degree",
        "is_orphan",
        "needs_review",
    ],
)

write_csv(
    OUTPUTS / "sustainability_relationship_type_summary.csv",
    [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
    ["relationship_type", "count"],
)

scale_counts = Counter(obj["scale"] for obj in objects)
write_csv(
    OUTPUTS / "sustainability_scale_summary.csv",
    [{"scale": key, "count": value} for key, value in scale_counts.items()],
    ["scale", "count"],
)

object_type_counts = Counter(obj["object_type"] for obj in objects)
write_csv(
    OUTPUTS / "sustainability_object_type_summary.csv",
    [{"object_type": key, "count": value} for key, value in object_type_counts.items()],
    ["object_type", "count"],
)

system_type_counts = Counter(system["system_type"] for system in systems)
write_csv(
    OUTPUTS / "sustainability_system_type_summary.csv",
    [{"system_type": key, "count": value} for key, value in system_type_counts.items()],
    ["system_type", "count"],
)

evidence_type_counts = Counter(evidence["evidence_type_id"] for evidence in evidence_types)
write_csv(
    OUTPUTS / "sustainability_evidence_type_inventory.csv",
    [{"evidence_type_id": key, "count": value} for key, value in evidence_type_counts.items()],
    ["evidence_type_id", "count"],
)

governance_severity_counts = Counter(check["severity"] for check in governance_checks)
write_csv(
    OUTPUTS / "sustainability_governance_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

summary = {
    "object_count": len(objects),
    "relationship_count": len(relationships),
    "system_count": len(systems),
    "concept_count": len(concepts),
    "evidence_type_count": len(evidence_types),
    "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / len(objects), 3),
    "justice_context_coverage": round(sum(row["has_justice_context"] for row in object_rows) / len(objects), 3),
    "uncertainty_context_coverage": round(sum(row["has_uncertainty_context"] for row in object_rows) / len(objects), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "underspecified_relationship_risk": round(underspecified / len(relationships), 3),
    "orphan_count": sum(row["is_orphan"] for row in object_rows),
    "review_needed_count": sum(row["needs_review"] for row in object_rows),
    "scale_count": len(scale_counts),
    "relationship_type_count": len(relationship_types),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "sustainability_knowledge_architecture_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote sustainability knowledge architecture diagnostics to:", OUTPUTS)
