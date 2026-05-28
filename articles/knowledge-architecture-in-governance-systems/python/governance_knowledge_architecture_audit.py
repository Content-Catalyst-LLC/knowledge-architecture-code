#!/usr/bin/env python3
"""
Governance Knowledge Architecture Audit

Audits a synthetic governance knowledge system for:
- metadata coverage
- accountability context coverage
- equity context coverage
- relationship traceability
- participation-response quality
- review and audit coverage
- underspecified relationship risk
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


objects = read_csv(DATA / "governance_objects.csv")
relationships = read_csv(DATA / "governance_relationships.csv")
institutions = read_csv(DATA / "institutions.csv")
rules_decisions = read_csv(DATA / "rules_and_decisions.csv")
evidence_sources = read_csv(DATA / "evidence_sources.csv")
participation_records = read_csv(DATA / "participation_records.csv")
budget_outcomes_audits = read_csv(DATA / "budget_outcomes_audits.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0
underspecified = 0
participation_links = 0
participation_response_links = 0
review_links = 0

for rel in relationships:
    degree[rel["source_object_id"]] += 1
    degree[rel["target_object_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1
    if rel["relationship_type"] in {"related", "sameAs", ""}:
        underspecified += 1
    if rel["relationship_type"] in {"participatesIn", "informsDecision"}:
        participation_links += 1
    if rel["relationship_type"] in {"informsDecision", "respondsToReview", "revises", "providesContestabilityFor"}:
        participation_response_links += 1
    if rel["relationship_type"] in {"reviews", "respondsToReview", "revises", "governsReviewOf"}:
        review_links += 1

object_rows = []
for obj in objects:
    object_id = obj["object_id"]
    has_metadata = truthy(obj["has_metadata"])
    has_accountability_context = truthy(obj["has_accountability_context"])
    has_equity_context = truthy(obj["has_equity_context"])
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
            "has_accountability_context": has_accountability_context,
            "has_equity_context": has_equity_context,
            "status": obj["status"],
            "relationship_degree": degree[object_id],
            "is_orphan": is_orphan,
            "needs_review": needs_review,
        }
    )

write_csv(
    OUTPUTS / "governance_object_diagnostics.csv",
    object_rows,
    [
        "object_id",
        "title",
        "object_type",
        "has_metadata",
        "has_accountability_context",
        "has_equity_context",
        "status",
        "relationship_degree",
        "is_orphan",
        "needs_review",
    ],
)

object_type_counts = Counter(obj["object_type"] for obj in objects)
write_csv(
    OUTPUTS / "governance_object_type_summary.csv",
    [{"object_type": key, "count": value} for key, value in object_type_counts.items()],
    ["object_type", "count"],
)

write_csv(
    OUTPUTS / "governance_relationship_type_summary.csv",
    [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
    ["relationship_type", "count"],
)

institution_type_counts = Counter(row["institution_type"] for row in institutions)
write_csv(
    OUTPUTS / "governance_institution_type_summary.csv",
    [{"institution_type": key, "count": value} for key, value in institution_type_counts.items()],
    ["institution_type", "count"],
)

evidence_type_counts = Counter(row["evidence_type"] for row in evidence_sources)
write_csv(
    OUTPUTS / "governance_evidence_type_summary.csv",
    [{"evidence_type": key, "count": value} for key, value in evidence_type_counts.items()],
    ["evidence_type", "count"],
)

participation_review_counts = Counter(row["review_status"] for row in participation_records)
write_csv(
    OUTPUTS / "governance_participation_review_summary.csv",
    [{"review_status": key, "count": value} for key, value in participation_review_counts.items()],
    ["review_status", "count"],
)

budget_audit_status_counts = Counter(row["review_status"] for row in budget_outcomes_audits)
write_csv(
    OUTPUTS / "governance_budget_outcome_audit_review_summary.csv",
    [{"review_status": key, "count": value} for key, value in budget_audit_status_counts.items()],
    ["review_status", "count"],
)

governance_severity_counts = Counter(row["severity"] for row in governance_checks)
write_csv(
    OUTPUTS / "governance_check_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

participation_response_coverage = sum(
    1 for row in participation_records
    if row["response_note"].strip() and row["influence_note"].strip()
) / len(participation_records)

summary = {
    "object_count": len(objects),
    "relationship_count": len(relationships),
    "institution_count": len(institutions),
    "rule_decision_record_count": len(rules_decisions),
    "evidence_source_count": len(evidence_sources),
    "participation_record_count": len(participation_records),
    "budget_outcome_audit_record_count": len(budget_outcomes_audits),
    "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / len(objects), 3),
    "accountability_context_coverage": round(sum(row["has_accountability_context"] for row in object_rows) / len(objects), 3),
    "equity_context_coverage": round(sum(row["has_equity_context"] for row in object_rows) / len(objects), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "underspecified_relationship_risk": round(underspecified / len(relationships), 3),
    "participation_response_coverage": round(participation_response_coverage, 3),
    "participation_link_share": round(participation_links / len(relationships), 3),
    "review_link_share": round(review_links / len(relationships), 3),
    "orphan_count": sum(row["is_orphan"] for row in object_rows),
    "review_needed_count": sum(row["needs_review"] for row in object_rows),
    "relationship_type_count": len(relationship_types),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "governance_knowledge_architecture_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote governance knowledge architecture diagnostics to:", OUTPUTS)
