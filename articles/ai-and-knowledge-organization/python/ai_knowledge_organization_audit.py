#!/usr/bin/env python3
"""
AI Knowledge Organization Audit

Audits a synthetic AI knowledge organization system for:
- metadata coverage
- provenance coverage
- review context coverage
- relationship traceability
- retrieval grounding
- source hierarchy coverage
- human review coverage
- correction readiness
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


objects = read_csv(DATA / "ai_ko_objects.csv")
relationships = read_csv(DATA / "ai_ko_relationships.csv")
metadata_fields = read_csv(DATA / "metadata_fields.csv")
taxonomy_terms = read_csv(DATA / "taxonomy_terms.csv")
retrieval_records = read_csv(DATA / "retrieval_records.csv")
ai_outputs = read_csv(DATA / "ai_outputs.csv")
source_hierarchy_rules = read_csv(DATA / "source_hierarchy_rules.csv")
human_review_records = read_csv(DATA / "human_review_records.csv")
correction_records = read_csv(DATA / "correction_records.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0
underspecified = 0
grounding_links = 0
review_links = 0
revision_links = 0
ranking_governance_links = 0

for rel in relationships:
    degree[rel["source_object_id"]] += 1
    degree[rel["target_object_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1
    if rel["relationship_type"] in {"related", "sameAs", ""}:
        underspecified += 1
    if rel["relationship_type"] in {"groundedBy", "retrieves", "describedBy", "groundsOutput"}:
        grounding_links += 1
    if rel["relationship_type"] == "reviews":
        review_links += 1
    if rel["relationship_type"] in {"revises", "updates"}:
        revision_links += 1
    if rel["relationship_type"] == "governsRankingOf":
        ranking_governance_links += 1

object_rows = []
for obj in objects:
    object_id = obj["object_id"]
    has_metadata = truthy(obj["has_metadata"])
    has_provenance = truthy(obj["has_provenance"])
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
            "has_review_context": has_review_context,
            "status": obj["status"],
            "relationship_degree": degree[object_id],
            "is_orphan": is_orphan,
            "needs_review": needs_review,
        }
    )

write_csv(
    OUTPUTS / "ai_ko_object_diagnostics.csv",
    object_rows,
    [
        "object_id",
        "title",
        "object_type",
        "has_metadata",
        "has_provenance",
        "has_review_context",
        "status",
        "relationship_degree",
        "is_orphan",
        "needs_review",
    ],
)

object_type_counts = Counter(obj["object_type"] for obj in objects)
write_csv(
    OUTPUTS / "ai_ko_object_type_summary.csv",
    [{"object_type": key, "count": value} for key, value in object_type_counts.items()],
    ["object_type", "count"],
)

write_csv(
    OUTPUTS / "ai_ko_relationship_type_summary.csv",
    [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
    ["relationship_type", "count"],
)

metadata_required_counts = Counter("required" if truthy(row["required"]) else "optional" for row in metadata_fields)
write_csv(
    OUTPUTS / "ai_ko_metadata_field_requirement_summary.csv",
    [{"field_requirement": key, "count": value} for key, value in metadata_required_counts.items()],
    ["field_requirement", "count"],
)

taxonomy_status_counts = Counter(row["review_status"] for row in taxonomy_terms)
write_csv(
    OUTPUTS / "ai_ko_taxonomy_review_status_summary.csv",
    [{"review_status": key, "count": value} for key, value in taxonomy_status_counts.items()],
    ["review_status", "count"],
)

retrieval_reviewed = sum(1 for row in retrieval_records if truthy(row["reviewed"]))
retrieval_rows = []
for row in retrieval_records:
    retrieval_rows.append(
        {
            "retrieval_id": row["retrieval_id"],
            "index_id": row["index_id"],
            "retrieved_object_id": row["retrieved_object_id"],
            "rank_position": row["rank_position"],
            "reviewed": truthy(row["reviewed"]),
            "needs_review": not truthy(row["reviewed"]),
        }
    )
write_csv(
    OUTPUTS / "ai_ko_retrieval_diagnostics.csv",
    retrieval_rows,
    ["retrieval_id", "index_id", "retrieved_object_id", "rank_position", "reviewed", "needs_review"],
)

ai_output_status_counts = Counter(row["review_status"] for row in ai_outputs)
write_csv(
    OUTPUTS / "ai_ko_ai_output_review_status_summary.csv",
    [{"review_status": key, "count": value} for key, value in ai_output_status_counts.items()],
    ["review_status", "count"],
)

source_rank_counts = Counter(row["authority_rank"] for row in source_hierarchy_rules)
write_csv(
    OUTPUTS / "ai_ko_source_authority_rank_summary.csv",
    [{"authority_rank": key, "count": value} for key, value in source_rank_counts.items()],
    ["authority_rank", "count"],
)

human_review_status_counts = Counter(row["review_status"] for row in human_review_records)
write_csv(
    OUTPUTS / "ai_ko_human_review_status_summary.csv",
    [{"review_status": key, "count": value} for key, value in human_review_status_counts.items()],
    ["review_status", "count"],
)

correction_type_counts = Counter(row["correction_type"] for row in correction_records)
write_csv(
    OUTPUTS / "ai_ko_correction_type_summary.csv",
    [{"correction_type": key, "count": value} for key, value in correction_type_counts.items()],
    ["correction_type", "count"],
)

governance_severity_counts = Counter(row["severity"] for row in governance_checks)
write_csv(
    OUTPUTS / "ai_ko_governance_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

summary = {
    "object_count": len(objects),
    "relationship_count": len(relationships),
    "metadata_field_count": len(metadata_fields),
    "taxonomy_term_count": len(taxonomy_terms),
    "retrieval_record_count": len(retrieval_records),
    "ai_output_count": len(ai_outputs),
    "source_hierarchy_rule_count": len(source_hierarchy_rules),
    "human_review_record_count": len(human_review_records),
    "correction_record_count": len(correction_records),
    "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / len(objects), 3),
    "provenance_coverage": round(sum(row["has_provenance"] for row in object_rows) / len(objects), 3),
    "review_context_coverage": round(sum(row["has_review_context"] for row in object_rows) / len(objects), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "underspecified_relationship_risk": round(underspecified / len(relationships), 3),
    "retrieval_review_coverage": round(retrieval_reviewed / len(retrieval_records), 3),
    "grounding_link_count": grounding_links,
    "review_link_count": review_links,
    "revision_link_count": revision_links,
    "ranking_governance_link_count": ranking_governance_links,
    "orphan_count": sum(row["is_orphan"] for row in object_rows),
    "review_needed_count": sum(row["needs_review"] for row in object_rows),
    "relationship_type_count": len(relationship_types),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "ai_knowledge_organization_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote AI knowledge organization diagnostics to:", OUTPUTS)
