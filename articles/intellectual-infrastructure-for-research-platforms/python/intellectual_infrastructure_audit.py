#!/usr/bin/env python3
"""
Intellectual Infrastructure Audit

Audits a synthetic research-platform infrastructure model for:
- metadata coverage
- governance coverage
- relationship traceability
- repository alignment
- orphaned objects
- review-priority signals
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
    objects = read_csv(DATA / "infrastructure_objects.csv")
    relationships = read_csv(DATA / "infrastructure_relationships.csv")
    repository_alignment = read_csv(DATA / "repository_alignment.csv")
    governance_checks = read_csv(DATA / "governance_checks.csv")
    metadata_requirements = read_csv(DATA / "metadata_requirements.csv")

    degree = defaultdict(int)
    relationship_types = Counter()
    traceable = 0

    for rel in relationships:
        degree[rel["source_object_id"]] += 1
        degree[rel["target_object_id"]] += 1
        relationship_types[rel["relationship_type"]] += 1
        if rel["provenance_note"].strip():
            traceable += 1

    object_rows = []
    for obj in objects:
        object_id = obj["object_id"]
        has_metadata = truthy(obj["has_metadata"])
        has_governance = truthy(obj["has_governance"])
        is_orphan = degree[object_id] == 0
        needs_review = not has_metadata or not has_governance or is_orphan

        object_rows.append(
            {
                "object_id": object_id,
                "title": obj["title"],
                "object_type": obj["object_type"],
                "has_metadata": has_metadata,
                "has_governance": has_governance,
                "status": obj["status"],
                "relationship_degree": degree[object_id],
                "is_orphan": is_orphan,
                "needs_review": needs_review,
            }
        )

    write_csv(
        OUTPUTS / "infrastructure_object_diagnostics.csv",
        object_rows,
        [
            "object_id",
            "title",
            "object_type",
            "has_metadata",
            "has_governance",
            "status",
            "relationship_degree",
            "is_orphan",
            "needs_review",
        ],
    )

    write_csv(
        OUTPUTS / "infrastructure_relationship_type_summary.csv",
        [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
        ["relationship_type", "count"],
    )

    aligned_count = sum(1 for row in repository_alignment if truthy(row["folder_exists_in_scaffold"]))
    repo_alignment = aligned_count / len(repository_alignment) if repository_alignment else 1.0

    severity_counts = Counter(check["severity"] for check in governance_checks)
    write_csv(
        OUTPUTS / "governance_check_severity_summary.csv",
        [{"severity": key, "count": value} for key, value in severity_counts.items()],
        ["severity", "count"],
    )

    object_count = len(objects)
    relationship_count = len(relationships)

    summary = {
        "object_count": object_count,
        "relationship_count": relationship_count,
        "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / object_count, 3),
        "governance_coverage": round(sum(row["has_governance"] for row in object_rows) / object_count, 3),
        "relationship_traceability": round(traceable / relationship_count, 3),
        "repository_alignment": round(repo_alignment, 3),
        "orphan_count": sum(row["is_orphan"] for row in object_rows),
        "review_needed_count": sum(row["needs_review"] for row in object_rows),
        "relationship_type_count": len(relationship_types),
        "governance_check_count": len(governance_checks),
        "metadata_requirement_count": len(metadata_requirements),
    }

    write_csv(
        OUTPUTS / "infrastructure_summary.csv",
        [{"metric": key, "value": value} for key, value in summary.items()],
        ["metric", "value"],
    )

    print("Wrote intellectual infrastructure diagnostics to:", OUTPUTS)


if __name__ == "__main__":
    main()
