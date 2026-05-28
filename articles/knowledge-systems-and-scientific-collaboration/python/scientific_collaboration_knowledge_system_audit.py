#!/usr/bin/env python3
"""
Scientific Collaboration Knowledge System Audit

Audits a synthetic scientific collaboration knowledge system for:
- metadata coverage
- provenance coverage
- review context coverage
- FAIR and open-science readiness
- contributor-role diversity
- reproducibility relationship coverage
- ethics and governance linkage
- AI-assisted research review readiness
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


objects = read_csv(DATA / "scientific_collaboration_objects.csv")
relationships = read_csv(DATA / "scientific_collaboration_relationships.csv")
contributors = read_csv(DATA / "contributors.csv")
datasets = read_csv(DATA / "datasets.csv")
protocols = read_csv(DATA / "protocols.csv")
software_artifacts = read_csv(DATA / "software_artifacts.csv")
publications_reviews_revisions = read_csv(DATA / "publications_reviews_revisions.csv")
ethics_governance_records = read_csv(DATA / "ethics_governance_records.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0
underspecified = 0
reproducibility_links = 0
review_links = 0
revision_links = 0
ethics_links = 0
repository_links = 0
ai_links = 0

for rel in relationships:
    degree[rel["source_object_id"]] += 1
    degree[rel["target_object_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1
    if rel["relationship_type"] in {"related", "sameAs", ""}:
        underspecified += 1
    if rel["relationship_type"] in {"describedBy", "analyzedBy", "dependsOn", "generates", "producesData", "supportsClaimIn"}:
        reproducibility_links += 1
    if rel["relationship_type"] in {"reviews", "tests"}:
        review_links += 1
    if rel["relationship_type"] in {"revises", "updates"}:
        revision_links += 1
    if rel["relationship_type"] == "governs":
        ethics_links += 1
    if rel["relationship_type"] == "stores":
        repository_links += 1
    if rel["source_object_id"].startswith("ai_") or rel["target_object_id"].startswith("ai_"):
        ai_links += 1

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
    OUTPUTS / "scientific_collaboration_object_diagnostics.csv",
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
    OUTPUTS / "scientific_collaboration_object_type_summary.csv",
    [{"object_type": key, "count": value} for key, value in object_type_counts.items()],
    ["object_type", "count"],
)

write_csv(
    OUTPUTS / "scientific_collaboration_relationship_type_summary.csv",
    [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
    ["relationship_type", "count"],
)

role_counts = Counter(row["role"] for row in contributors)
write_csv(
    OUTPUTS / "scientific_collaboration_contributor_role_summary.csv",
    [{"role": key, "count": value} for key, value in role_counts.items()],
    ["role", "count"],
)

institution_counts = Counter(row["institution"] for row in contributors)
write_csv(
    OUTPUTS / "scientific_collaboration_institution_summary.csv",
    [{"institution": key, "count": value} for key, value in institution_counts.items()],
    ["institution", "count"],
)

dataset_status_counts = Counter(row["review_status"] for row in datasets)
write_csv(
    OUTPUTS / "scientific_collaboration_dataset_review_status_summary.csv",
    [{"review_status": key, "count": value} for key, value in dataset_status_counts.items()],
    ["review_status", "count"],
)

protocol_status_counts = Counter(row["review_status"] for row in protocols)
write_csv(
    OUTPUTS / "scientific_collaboration_protocol_review_status_summary.csv",
    [{"review_status": key, "count": value} for key, value in protocol_status_counts.items()],
    ["review_status", "count"],
)

software_status_counts = Counter(row["review_status"] for row in software_artifacts)
write_csv(
    OUTPUTS / "scientific_collaboration_software_review_status_summary.csv",
    [{"review_status": key, "count": value} for key, value in software_status_counts.items()],
    ["review_status", "count"],
)

publication_record_counts = Counter(row["record_type"] for row in publications_reviews_revisions)
write_csv(
    OUTPUTS / "scientific_collaboration_publication_record_type_summary.csv",
    [{"record_type": key, "count": value} for key, value in publication_record_counts.items()],
    ["record_type", "count"],
)

ethics_record_counts = Counter(row["record_type"] for row in ethics_governance_records)
write_csv(
    OUTPUTS / "scientific_collaboration_ethics_governance_type_summary.csv",
    [{"record_type": key, "count": value} for key, value in ethics_record_counts.items()],
    ["record_type", "count"],
)

governance_severity_counts = Counter(row["severity"] for row in governance_checks)
write_csv(
    OUTPUTS / "scientific_collaboration_governance_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

summary = {
    "object_count": len(objects),
    "relationship_count": len(relationships),
    "contributor_count": len(contributors),
    "contributor_role_count": len(role_counts),
    "institution_count": len(institution_counts),
    "dataset_count": len(datasets),
    "protocol_count": len(protocols),
    "software_artifact_count": len(software_artifacts),
    "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / len(objects), 3),
    "provenance_coverage": round(sum(row["has_provenance"] for row in object_rows) / len(objects), 3),
    "review_context_coverage": round(sum(row["has_review_context"] for row in object_rows) / len(objects), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "underspecified_relationship_risk": round(underspecified / len(relationships), 3),
    "reproducibility_link_count": reproducibility_links,
    "review_link_count": review_links,
    "revision_link_count": revision_links,
    "ethics_link_count": ethics_links,
    "repository_link_count": repository_links,
    "ai_assisted_research_link_count": ai_links,
    "orphan_count": sum(row["is_orphan"] for row in object_rows),
    "review_needed_count": sum(row["needs_review"] for row in object_rows),
    "object_type_count": len(object_type_counts),
    "relationship_type_count": len(relationship_types),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "scientific_collaboration_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote scientific collaboration diagnostics to:", OUTPUTS)
