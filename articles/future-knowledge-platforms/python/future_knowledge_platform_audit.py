#!/usr/bin/env python3
"""
Future Knowledge Platform Audit

Audits a synthetic future knowledge platform for:
- metadata coverage
- provenance coverage
- reuse readiness
- review context coverage
- AI grounding
- repository support
- governance coverage
- accessibility coverage
- resilience readiness
- relationship traceability
- underspecified relationship risk
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


objects = read_csv(DATA / "future_platform_objects.csv")
relationships = read_csv(DATA / "future_platform_relationships.csv")
repositories = read_csv(DATA / "repositories.csv")
metadata_fields = read_csv(DATA / "metadata_fields.csv")
ai_records = read_csv(DATA / "ai_records.csv")
governance_records = read_csv(DATA / "governance_records.csv")
accessibility_records = read_csv(DATA / "accessibility_records.csv")
reuse_conditions = read_csv(DATA / "reuse_conditions.csv")
resilience_records = read_csv(DATA / "resilience_records.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0
underspecified = 0
ai_grounding_links = 0
repository_links = 0
governance_links = 0
revision_links = 0
accessibility_links = 0
resilience_links = 0

for rel in relationships:
    degree[rel["source_object_id"]] += 1
    degree[rel["target_object_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1
    if rel["relationship_type"] in {"related", "sameAs", ""}:
        underspecified += 1
    if rel["relationship_type"] in {"retrieves", "groundedBy"}:
        ai_grounding_links += 1
    if rel["relationship_type"] == "supportedByRepository":
        repository_links += 1
    if rel["relationship_type"] in {"requiresReview", "governsRankingOf"}:
        governance_links += 1
    if rel["relationship_type"] == "updates":
        revision_links += 1
    if rel["relationship_type"] == "reviewsAccessibilityOf":
        accessibility_links += 1
    if rel["relationship_type"] == "stewards":
        resilience_links += 1

object_rows = []
for obj in objects:
    object_id = obj["object_id"]
    has_metadata = truthy(obj["has_metadata"])
    has_provenance = truthy(obj["has_provenance"])
    has_reuse_context = truthy(obj["has_reuse_context"])
    has_review_context = truthy(obj["has_review_context"])
    is_orphan = degree[object_id] == 0
    needs_review = (
        not has_metadata
        or not has_provenance
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
            "has_provenance": has_provenance,
            "has_reuse_context": has_reuse_context,
            "has_review_context": has_review_context,
            "status": obj["status"],
            "relationship_degree": degree[object_id],
            "is_orphan": is_orphan,
            "needs_review": needs_review,
        }
    )

write_csv(
    OUTPUTS / "future_platform_object_diagnostics.csv",
    object_rows,
    [
        "object_id",
        "title",
        "object_type",
        "has_metadata",
        "has_provenance",
        "has_reuse_context",
        "has_review_context",
        "status",
        "relationship_degree",
        "is_orphan",
        "needs_review",
    ],
)

object_type_counts = Counter(obj["object_type"] for obj in objects)
write_csv(
    OUTPUTS / "future_platform_object_type_summary.csv",
    [{"object_type": key, "count": value} for key, value in object_type_counts.items()],
    ["object_type", "count"],
)

write_csv(
    OUTPUTS / "future_platform_relationship_type_summary.csv",
    [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
    ["relationship_type", "count"],
)

repository_status_counts = Counter(row["review_status"] for row in repositories)
write_csv(
    OUTPUTS / "future_platform_repository_review_status_summary.csv",
    [{"review_status": key, "count": value} for key, value in repository_status_counts.items()],
    ["review_status", "count"],
)

metadata_required_counts = Counter("required" if truthy(row["required"]) else "optional" for row in metadata_fields)
write_csv(
    OUTPUTS / "future_platform_metadata_requirement_summary.csv",
    [{"field_requirement": key, "count": value} for key, value in metadata_required_counts.items()],
    ["field_requirement", "count"],
)

ai_review_counts = Counter(row["human_review_status"] for row in ai_records)
write_csv(
    OUTPUTS / "future_platform_ai_review_status_summary.csv",
    [{"human_review_status": key, "count": value} for key, value in ai_review_counts.items()],
    ["human_review_status", "count"],
)

governance_status_counts = Counter(row["review_status"] for row in governance_records)
write_csv(
    OUTPUTS / "future_platform_governance_status_summary.csv",
    [{"review_status": key, "count": value} for key, value in governance_status_counts.items()],
    ["review_status", "count"],
)

accessibility_rows = []
for row in accessibility_records:
    checks = [
        truthy(row["has_alt_text"]),
        truthy(row["has_captions"]),
        truthy(row["has_transcript"]),
    ]
    accessibility_rows.append(
        {
            "object_id": row["object_id"],
            "accessibility_completeness": round(sum(checks) / len(checks), 3),
            "semantic_structure_status": row["semantic_structure_status"],
            "review_status": row["review_status"],
            "needs_review": row["review_status"] == "needs_review" or sum(checks) < len(checks),
        }
    )

write_csv(
    OUTPUTS / "future_platform_accessibility_diagnostics.csv",
    accessibility_rows,
    ["object_id", "accessibility_completeness", "semantic_structure_status", "review_status", "needs_review"],
)

reuse_status_counts = Counter(row["review_status"] for row in reuse_conditions)
write_csv(
    OUTPUTS / "future_platform_reuse_status_summary.csv",
    [{"review_status": key, "count": value} for key, value in reuse_status_counts.items()],
    ["review_status", "count"],
)

resilience_status_counts = Counter(row["status"] for row in resilience_records)
write_csv(
    OUTPUTS / "future_platform_resilience_status_summary.csv",
    [{"status": key, "count": value} for key, value in resilience_status_counts.items()],
    ["status", "count"],
)

governance_severity_counts = Counter(row["severity"] for row in governance_checks)
write_csv(
    OUTPUTS / "future_platform_governance_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

summary = {
    "object_count": len(objects),
    "relationship_count": len(relationships),
    "repository_count": len(repositories),
    "metadata_field_count": len(metadata_fields),
    "ai_record_count": len(ai_records),
    "governance_record_count": len(governance_records),
    "accessibility_record_count": len(accessibility_records),
    "reuse_condition_count": len(reuse_conditions),
    "resilience_record_count": len(resilience_records),
    "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / len(objects), 3),
    "provenance_coverage": round(sum(row["has_provenance"] for row in object_rows) / len(objects), 3),
    "reuse_context_coverage": round(sum(row["has_reuse_context"] for row in object_rows) / len(objects), 3),
    "review_context_coverage": round(sum(row["has_review_context"] for row in object_rows) / len(objects), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "underspecified_relationship_risk": round(underspecified / len(relationships), 3),
    "accessibility_mean_completeness": round(sum(row["accessibility_completeness"] for row in accessibility_rows) / len(accessibility_rows), 3),
    "ai_grounding_link_count": ai_grounding_links,
    "repository_link_count": repository_links,
    "governance_link_count": governance_links,
    "revision_link_count": revision_links,
    "accessibility_link_count": accessibility_links,
    "resilience_link_count": resilience_links,
    "orphan_count": sum(row["is_orphan"] for row in object_rows),
    "review_needed_count": sum(row["needs_review"] for row in object_rows),
    "object_type_count": len(object_type_counts),
    "relationship_type_count": len(relationship_types),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "future_knowledge_platform_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote future knowledge platform diagnostics to:", OUTPUTS)
