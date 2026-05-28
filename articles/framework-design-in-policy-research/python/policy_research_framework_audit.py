#!/usr/bin/env python3
"""
Policy Research Framework Audit

Audits a synthetic policy framework model for:
- metadata coverage
- equity context coverage
- causal context coverage
- relationship traceability
- underspecified relationship risk
- object type distribution
- weighted option scores
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


objects = read_csv(DATA / "policy_framework_objects.csv")
relationships = read_csv(DATA / "policy_framework_relationships.csv")
criteria = read_csv(DATA / "decision_criteria.csv")
scores = read_csv(DATA / "option_scores.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")
stakeholders = read_csv(DATA / "stakeholders.csv")
evidence_sources = read_csv(DATA / "evidence_sources.csv")

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
    has_equity_context = truthy(obj["has_equity_context"])
    has_causal_context = truthy(obj["has_causal_context"])
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
            "has_equity_context": has_equity_context,
            "has_causal_context": has_causal_context,
            "status": obj["status"],
            "relationship_degree": degree[object_id],
            "is_orphan": is_orphan,
            "needs_review": needs_review,
        }
    )

write_csv(
    OUTPUTS / "policy_framework_object_diagnostics.csv",
    object_rows,
    [
        "object_id",
        "title",
        "object_type",
        "has_metadata",
        "has_equity_context",
        "has_causal_context",
        "status",
        "relationship_degree",
        "is_orphan",
        "needs_review",
    ],
)

object_type_counts = Counter(obj["object_type"] for obj in objects)
write_csv(
    OUTPUTS / "policy_framework_object_type_summary.csv",
    [{"object_type": key, "count": value} for key, value in object_type_counts.items()],
    ["object_type", "count"],
)

write_csv(
    OUTPUTS / "policy_framework_relationship_type_summary.csv",
    [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
    ["relationship_type", "count"],
)

criteria_weights = {row["criterion_id"]: float(row["weight"]) for row in criteria}
weighted_scores = defaultdict(float)
weight_totals = defaultdict(float)

for row in scores:
    option_id = row["option_id"]
    criterion_id = row["criterion_id"]
    weight = criteria_weights.get(criterion_id, 0.0)
    weighted_scores[option_id] += float(row["score"]) * weight
    weight_totals[option_id] += weight

option_score_rows = []
for option_id, total in weighted_scores.items():
    normalized = total / weight_totals[option_id] if weight_totals[option_id] else 0
    option_score_rows.append(
        {
            "option_id": option_id,
            "weighted_score": round(normalized, 3),
            "covered_weight": round(weight_totals[option_id], 3),
        }
    )

write_csv(
    OUTPUTS / "policy_option_weighted_scores.csv",
    option_score_rows,
    ["option_id", "weighted_score", "covered_weight"],
)

stakeholder_type_counts = Counter(row["stakeholder_type"] for row in stakeholders)
write_csv(
    OUTPUTS / "stakeholder_type_summary.csv",
    [{"stakeholder_type": key, "count": value} for key, value in stakeholder_type_counts.items()],
    ["stakeholder_type", "count"],
)

evidence_type_counts = Counter(row["evidence_type"] for row in evidence_sources)
write_csv(
    OUTPUTS / "evidence_type_summary.csv",
    [{"evidence_type": key, "count": value} for key, value in evidence_type_counts.items()],
    ["evidence_type", "count"],
)

governance_severity_counts = Counter(row["severity"] for row in governance_checks)
write_csv(
    OUTPUTS / "policy_framework_governance_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

summary = {
    "object_count": len(objects),
    "relationship_count": len(relationships),
    "evidence_source_count": len(evidence_sources),
    "stakeholder_count": len(stakeholders),
    "criterion_count": len(criteria),
    "option_score_count": len(scores),
    "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / len(objects), 3),
    "equity_context_coverage": round(sum(row["has_equity_context"] for row in object_rows) / len(objects), 3),
    "causal_context_coverage": round(sum(row["has_causal_context"] for row in object_rows) / len(objects), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "underspecified_relationship_risk": round(underspecified / len(relationships), 3),
    "orphan_count": sum(row["is_orphan"] for row in object_rows),
    "review_needed_count": sum(row["needs_review"] for row in object_rows),
    "relationship_type_count": len(relationship_types),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "policy_framework_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote policy framework diagnostics to:", OUTPUTS)
