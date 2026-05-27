#!/usr/bin/env python3
"""
Digital Knowledge Platform Audit

Audits a synthetic digital knowledge platform for:
- metadata coverage
- relationship traceability
- repository alignment
- orphaned objects
- relationship type distribution
- governance check inventory
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


def main() -> None:
    objects = read_csv(DATA / "platform_objects.csv")
    relationships = read_csv(DATA / "platform_relationships.csv")
    repository_alignment = read_csv(DATA / "repository_alignment.csv")
    governance_checks = read_csv(DATA / "governance_checks.csv")
    metadata_requirements = read_csv(DATA / "metadata_requirements.csv")

    degree = defaultdict(int)
    relationship_types = Counter()
    traceable_relationships = 0

    for rel in relationships:
        degree[rel["source_object_id"]] += 1
        degree[rel["target_object_id"]] += 1
        relationship_types[rel["relationship_type"]] += 1
        if rel["provenance_note"].strip():
            traceable_relationships += 1

    object_rows = []
    for obj in objects:
        object_id = obj["object_id"]
        object_rows.append(
            {
                "object_id": object_id,
                "title": obj["title"],
                "object_type": obj["object_type"],
                "slug": obj["slug"],
                "status": obj["status"],
                "has_metadata": truthy(obj["has_metadata"]),
                "relationship_degree": degree[object_id],
                "is_orphan": degree[object_id] == 0,
            }
        )

    write_csv(
        OUTPUTS / "platform_object_diagnostics.csv",
        object_rows,
        [
            "object_id",
            "title",
            "object_type",
            "slug",
            "status",
            "has_metadata",
            "relationship_degree",
            "is_orphan",
        ],
    )

    write_csv(
        OUTPUTS / "platform_relationship_type_summary.csv",
        [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
        ["relationship_type", "count"],
    )

    repo_rows = []
    aligned_count = 0
    for row in repository_alignment:
        folder_exists = truthy(row["folder_exists_in_scaffold"])
        has_repository = bool(row["repository_id"].strip())
        aligned = folder_exists and (has_repository or row["article_id"] != "digital_platforms")
        if aligned:
            aligned_count += 1
        repo_rows.append(
            {
                "article_id": row["article_id"],
                "repository_id": row["repository_id"],
                "expected_slug": row["expected_slug"],
                "folder_exists_in_scaffold": folder_exists,
                "alignment_status": "aligned" if aligned else "needs_review",
            }
        )

    write_csv(
        OUTPUTS / "repository_alignment_diagnostics.csv",
        repo_rows,
        [
            "article_id",
            "repository_id",
            "expected_slug",
            "folder_exists_in_scaffold",
            "alignment_status",
        ],
    )

    severity_counts = Counter(check["severity"] for check in governance_checks)
    write_csv(
        OUTPUTS / "governance_check_summary.csv",
        [{"severity": key, "count": value} for key, value in severity_counts.items()],
        ["severity", "count"],
    )

    object_count = len(objects)
    relationship_count = len(relationships)

    summary = {
        "object_count": object_count,
        "relationship_count": relationship_count,
        "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / object_count, 3),
        "relationship_traceability": round(traceable_relationships / relationship_count, 3),
        "repository_alignment": round(aligned_count / len(repository_alignment), 3),
        "orphan_count": sum(row["is_orphan"] for row in object_rows),
        "relationship_type_count": len(relationship_types),
        "metadata_requirement_count": len(metadata_requirements),
        "governance_check_count": len(governance_checks),
    }

    write_csv(
        OUTPUTS / "platform_summary.csv",
        [{"metric": key, "value": value} for key, value in summary.items()],
        ["metric", "value"],
    )

    print("Wrote digital knowledge platform diagnostics to:", OUTPUTS)


if __name__ == "__main__":
    main()
