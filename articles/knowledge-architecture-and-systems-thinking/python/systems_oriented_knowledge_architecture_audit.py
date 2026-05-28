#!/usr/bin/env python3
"""
Systems-Oriented Knowledge Architecture Audit

Audits a synthetic systems-thinking knowledge architecture for:
- metadata coverage
- scale diversity
- relationship traceability
- feedback edge share
- feedback role coverage
- underspecified relationship risk
- assumption sensitivity
- evidence-link coverage
- governance review needs
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


objects = read_csv(DATA / "knowledge_objects.csv")
relationships = read_csv(DATA / "knowledge_relationships.csv")
feedback_loops = read_csv(DATA / "feedback_loops.csv")
assumptions = read_csv(DATA / "assumptions.csv")
evidence_links = read_csv(DATA / "evidence_links.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0
feedback_edges = 0
underspecified = 0

for rel in relationships:
    degree[rel["source_object_id"]] += 1
    degree[rel["target_object_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1
    if truthy(rel["feedback_relevant"]):
        feedback_edges += 1
    if rel["relationship_type"] in {"related", "sameAs", ""}:
        underspecified += 1

object_rows = []
for obj in objects:
    object_id = obj["object_id"]
    has_metadata = truthy(obj["has_metadata"])
    has_feedback_role = truthy(obj["has_feedback_role"])
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
            "has_feedback_role": has_feedback_role,
            "status": obj["status"],
            "relationship_degree": degree[object_id],
            "is_orphan": is_orphan,
            "needs_review": needs_review,
        }
    )

write_csv(
    OUTPUTS / "systems_knowledge_object_diagnostics.csv",
    object_rows,
    [
        "object_id",
        "title",
        "object_type",
        "has_metadata",
        "scale",
        "has_feedback_role",
        "status",
        "relationship_degree",
        "is_orphan",
        "needs_review",
    ],
)

object_type_counts = Counter(obj["object_type"] for obj in objects)
write_csv(
    OUTPUTS / "systems_knowledge_object_type_summary.csv",
    [{"object_type": key, "count": value} for key, value in object_type_counts.items()],
    ["object_type", "count"],
)

scale_counts = Counter(obj["scale"] for obj in objects)
write_csv(
    OUTPUTS / "systems_knowledge_scale_summary.csv",
    [{"scale": key, "count": value} for key, value in scale_counts.items()],
    ["scale", "count"],
)

write_csv(
    OUTPUTS / "systems_knowledge_relationship_type_summary.csv",
    [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
    ["relationship_type", "count"],
)

loop_type_counts = Counter(loop["loop_type"] for loop in feedback_loops)
write_csv(
    OUTPUTS / "systems_knowledge_feedback_loop_summary.csv",
    [{"loop_type": key, "count": value} for key, value in loop_type_counts.items()],
    ["loop_type", "count"],
)

assumption_sensitivity_counts = Counter(assumption["sensitivity_level"] for assumption in assumptions)
write_csv(
    OUTPUTS / "systems_knowledge_assumption_sensitivity_summary.csv",
    [{"sensitivity_level": key, "count": value} for key, value in assumption_sensitivity_counts.items()],
    ["sensitivity_level", "count"],
)

evidence_type_counts = Counter(evidence["evidence_type"] for evidence in evidence_links)
write_csv(
    OUTPUTS / "systems_knowledge_evidence_type_summary.csv",
    [{"evidence_type": key, "count": value} for key, value in evidence_type_counts.items()],
    ["evidence_type", "count"],
)

governance_severity_counts = Counter(check["severity"] for check in governance_checks)
write_csv(
    OUTPUTS / "systems_knowledge_governance_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

summary = {
    "object_count": len(objects),
    "relationship_count": len(relationships),
    "feedback_loop_count": len(feedback_loops),
    "assumption_count": len(assumptions),
    "evidence_link_count": len(evidence_links),
    "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / len(objects), 3),
    "feedback_role_coverage": round(sum(row["has_feedback_role"] for row in object_rows) / len(objects), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "feedback_edge_share": round(feedback_edges / len(relationships), 3),
    "underspecified_relationship_risk": round(underspecified / len(relationships), 3),
    "scale_count": len(scale_counts),
    "object_type_count": len(object_type_counts),
    "orphan_count": sum(row["is_orphan"] for row in object_rows),
    "review_needed_count": sum(row["needs_review"] for row in object_rows),
    "relationship_type_count": len(relationship_types),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "systems_knowledge_architecture_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote systems-oriented knowledge architecture diagnostics to:", OUTPUTS)
