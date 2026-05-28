#!/usr/bin/env python3
"""
Decision Knowledge System Audit

Audits a synthetic decision knowledge system for:
- metadata coverage
- equity context coverage
- review context coverage
- evidence-to-decision traceability
- feedback link coverage
- underspecified relationship risk
- option weighted scores
- governance and review needs
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


objects = read_csv(DATA / "decision_objects.csv")
relationships = read_csv(DATA / "decision_relationships.csv")
criteria = read_csv(DATA / "decision_criteria.csv")
scores = read_csv(DATA / "option_scores.csv")
evidence_sources = read_csv(DATA / "evidence_sources.csv")
actors = read_csv(DATA / "actors.csv")
assumptions = read_csv(DATA / "assumptions.csv")
outcomes_feedback = read_csv(DATA / "outcomes_and_feedback.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0
underspecified = 0
feedback_links = 0

for rel in relationships:
    degree[rel["source_object_id"]] += 1
    degree[rel["target_object_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1
    if rel["relationship_type"] in {"related", "sameAs", ""}:
        underspecified += 1
    if "feedback" in rel["relationship_type"].lower() or rel["relationship_type"] == "feedsBackTo":
        feedback_links += 1

object_rows = []
for obj in objects:
    object_id = obj["object_id"]
    has_metadata = truthy(obj["has_metadata"])
    has_equity_context = truthy(obj["has_equity_context"])
    has_review_context = truthy(obj["has_review_context"])
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
            "has_review_context": has_review_context,
            "status": obj["status"],
            "relationship_degree": degree[object_id],
            "is_orphan": is_orphan,
            "needs_review": needs_review,
        }
    )

write_csv(
    OUTPUTS / "decision_object_diagnostics.csv",
    object_rows,
    [
        "object_id",
        "title",
        "object_type",
        "has_metadata",
        "has_equity_context",
        "has_review_context",
        "status",
        "relationship_degree",
        "is_orphan",
        "needs_review",
    ],
)

object_type_counts = Counter(obj["object_type"] for obj in objects)
write_csv(
    OUTPUTS / "decision_object_type_summary.csv",
    [{"object_type": key, "count": value} for key, value in object_type_counts.items()],
    ["object_type", "count"],
)

write_csv(
    OUTPUTS / "decision_relationship_type_summary.csv",
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
    OUTPUTS / "decision_option_weighted_scores.csv",
    option_score_rows,
    ["option_id", "weighted_score", "covered_weight"],
)

evidence_type_counts = Counter(row["evidence_type"] for row in evidence_sources)
write_csv(
    OUTPUTS / "decision_evidence_type_summary.csv",
    [{"evidence_type": key, "count": value} for key, value in evidence_type_counts.items()],
    ["evidence_type", "count"],
)

actor_type_counts = Counter(row["actor_type"] for row in actors)
write_csv(
    OUTPUTS / "decision_actor_type_summary.csv",
    [{"actor_type": key, "count": value} for key, value in actor_type_counts.items()],
    ["actor_type", "count"],
)

assumption_sensitivity_counts = Counter(row["sensitivity_level"] for row in assumptions)
write_csv(
    OUTPUTS / "decision_assumption_sensitivity_summary.csv",
    [{"sensitivity_level": key, "count": value} for key, value in assumption_sensitivity_counts.items()],
    ["sensitivity_level", "count"],
)

outcome_feedback_status_counts = Counter(row["review_status"] for row in outcomes_feedback)
write_csv(
    OUTPUTS / "decision_outcome_feedback_review_summary.csv",
    [{"review_status": key, "count": value} for key, value in outcome_feedback_status_counts.items()],
    ["review_status", "count"],
)

governance_severity_counts = Counter(row["severity"] for row in governance_checks)
write_csv(
    OUTPUTS / "decision_governance_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

summary = {
    "object_count": len(objects),
    "relationship_count": len(relationships),
    "evidence_source_count": len(evidence_sources),
    "actor_count": len(actors),
    "assumption_count": len(assumptions),
    "outcome_feedback_record_count": len(outcomes_feedback),
    "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / len(objects), 3),
    "equity_context_coverage": round(sum(row["has_equity_context"] for row in object_rows) / len(objects), 3),
    "review_context_coverage": round(sum(row["has_review_context"] for row in object_rows) / len(objects), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "underspecified_relationship_risk": round(underspecified / len(relationships), 3),
    "feedback_link_share": round(feedback_links / len(relationships), 3),
    "orphan_count": sum(row["is_orphan"] for row in object_rows),
    "review_needed_count": sum(row["needs_review"] for row in object_rows),
    "relationship_type_count": len(relationship_types),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "decision_knowledge_system_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote decision knowledge system diagnostics to:", OUTPUTS)
