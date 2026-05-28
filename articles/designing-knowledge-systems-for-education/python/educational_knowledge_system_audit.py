#!/usr/bin/env python3
"""
Educational Knowledge System Audit

Audits a synthetic educational knowledge system for:
- metadata coverage
- accessibility coverage
- review context coverage
- objective-resource-assessment alignment
- feedback loop coverage
- relationship traceability
- underspecified relationship risk
- resource accessibility status
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


objects = read_csv(DATA / "educational_objects.csv")
relationships = read_csv(DATA / "educational_relationships.csv")
resources = read_csv(DATA / "learning_resources.csv")
accessibility = read_csv(DATA / "accessibility_metadata.csv")
objectives = read_csv(DATA / "learning_objectives.csv")
assessments_feedback = read_csv(DATA / "assessments_and_feedback.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0
underspecified = 0
assessment_links = 0
feedback_links = 0
objective_links = 0
resource_links = 0

for rel in relationships:
    degree[rel["source_object_id"]] += 1
    degree[rel["target_object_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1
    if rel["relationship_type"] in {"related", "sameAs", ""}:
        underspecified += 1
    if rel["relationship_type"] == "assessesObjective":
        assessment_links += 1
    if rel["relationship_type"] in {"generatesFeedback", "feedsBackTo"}:
        feedback_links += 1
    if "Objective" in rel["relationship_type"]:
        objective_links += 1
    if rel["relationship_type"] in {"teachesObjective", "illustratesObjective", "practicesObjective", "storesResource"}:
        resource_links += 1

object_rows = []
for obj in objects:
    object_id = obj["object_id"]
    has_metadata = truthy(obj["has_metadata"])
    has_accessibility_context = truthy(obj["has_accessibility_context"])
    has_review_context = truthy(obj["has_review_context"])
    is_orphan = degree[object_id] == 0
    needs_review = (
        not has_metadata
        or not has_accessibility_context
        or not has_review_context
        or obj["status"] == "review_needed"
        or is_orphan
    )
    object_rows.append(
        {
            "object_id": object_id,
            "title": obj["title"],
            "object_type": obj["object_type"],
            "has_metadata": has_metadata,
            "has_accessibility_context": has_accessibility_context,
            "has_review_context": has_review_context,
            "status": obj["status"],
            "relationship_degree": degree[object_id],
            "is_orphan": is_orphan,
            "needs_review": needs_review,
        }
    )

write_csv(
    OUTPUTS / "educational_object_diagnostics.csv",
    object_rows,
    [
        "object_id",
        "title",
        "object_type",
        "has_metadata",
        "has_accessibility_context",
        "has_review_context",
        "status",
        "relationship_degree",
        "is_orphan",
        "needs_review",
    ],
)

object_type_counts = Counter(obj["object_type"] for obj in objects)
write_csv(
    OUTPUTS / "educational_object_type_summary.csv",
    [{"object_type": key, "count": value} for key, value in object_type_counts.items()],
    ["object_type", "count"],
)

write_csv(
    OUTPUTS / "educational_relationship_type_summary.csv",
    [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
    ["relationship_type", "count"],
)

resource_type_counts = Counter(row["resource_type"] for row in resources)
write_csv(
    OUTPUTS / "educational_resource_type_summary.csv",
    [{"resource_type": key, "count": value} for key, value in resource_type_counts.items()],
    ["resource_type", "count"],
)

difficulty_counts = Counter(row["difficulty_level"] for row in resources)
write_csv(
    OUTPUTS / "educational_resource_difficulty_summary.csv",
    [{"difficulty_level": key, "count": value} for key, value in difficulty_counts.items()],
    ["difficulty_level", "count"],
)

accessibility_rows = []
for row in accessibility:
    checks = [
        truthy(row["has_alt_text"]),
        truthy(row["has_captions"]),
        truthy(row["has_transcript"]),
        truthy(row["keyboard_accessible"]),
    ]
    accessibility_rows.append(
        {
            "resource_id": row["resource_id"],
            "accessibility_completeness": round(sum(checks) / len(checks), 3),
            "review_status": row["review_status"],
            "needs_review": row["review_status"] == "needs_review" or sum(checks) < len(checks),
        }
    )

write_csv(
    OUTPUTS / "educational_accessibility_diagnostics.csv",
    accessibility_rows,
    ["resource_id", "accessibility_completeness", "review_status", "needs_review"],
)

cognitive_level_counts = Counter(row["cognitive_level"] for row in objectives)
write_csv(
    OUTPUTS / "educational_cognitive_level_summary.csv",
    [{"cognitive_level": key, "count": value} for key, value in cognitive_level_counts.items()],
    ["cognitive_level", "count"],
)

assessment_feedback_type_counts = Counter(row["record_type"] for row in assessments_feedback)
write_csv(
    OUTPUTS / "educational_assessment_feedback_type_summary.csv",
    [{"record_type": key, "count": value} for key, value in assessment_feedback_type_counts.items()],
    ["record_type", "count"],
)

governance_severity_counts = Counter(row["severity"] for row in governance_checks)
write_csv(
    OUTPUTS / "educational_governance_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

summary = {
    "object_count": len(objects),
    "relationship_count": len(relationships),
    "resource_count": len(resources),
    "learning_objective_count": len(objectives),
    "assessment_feedback_record_count": len(assessments_feedback),
    "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / len(objects), 3),
    "accessibility_context_coverage": round(sum(row["has_accessibility_context"] for row in object_rows) / len(objects), 3),
    "review_context_coverage": round(sum(row["has_review_context"] for row in object_rows) / len(objects), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "underspecified_relationship_risk": round(underspecified / len(relationships), 3),
    "assessment_alignment_links": assessment_links,
    "feedback_link_count": feedback_links,
    "objective_link_count": objective_links,
    "resource_link_count": resource_links,
    "accessibility_record_mean_completeness": round(sum(row["accessibility_completeness"] for row in accessibility_rows) / len(accessibility_rows), 3),
    "orphan_count": sum(row["is_orphan"] for row in object_rows),
    "review_needed_count": sum(row["needs_review"] for row in object_rows),
    "relationship_type_count": len(relationship_types),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "educational_knowledge_system_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote educational knowledge system diagnostics to:", OUTPUTS)
