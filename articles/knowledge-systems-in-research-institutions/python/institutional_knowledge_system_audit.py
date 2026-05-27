#!/usr/bin/env python3
"""
Institutional Knowledge System Audit

Audits a synthetic research-institution knowledge system for:
- metadata coverage
- relationship traceability
- object degree and orphan status
- access-level distribution
- governance review status
- stewardship risk signals
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
    objects = read_csv(DATA / "research_objects.csv")
    relationships = read_csv(DATA / "object_relationships.csv")
    governance_records = read_csv(DATA / "governance_records.csv")
    metadata_requirements = read_csv(DATA / "metadata_requirements.csv")
    stewardship_checks = read_csv(DATA / "stewardship_checks.csv")

    degree = defaultdict(int)
    relationship_types = Counter()
    traceable = 0

    for rel in relationships:
        degree[rel["source_object_id"]] += 1
        degree[rel["target_object_id"]] += 1
        relationship_types[rel["relationship_type"]] += 1
        if rel["provenance_note"].strip():
            traceable += 1

    governance_by_object = defaultdict(list)
    for record in governance_records:
        governance_by_object[record["object_id"]].append(record)

    object_rows = []
    for obj in objects:
        object_id = obj["object_id"]
        governance_statuses = [record["review_status"] for record in governance_by_object[object_id]]
        needs_review = (
            not truthy(obj["has_metadata"])
            or degree[object_id] == 0
            or "needs_review" in governance_statuses
            or obj["access_level"] in {"restricted", "community_governed"} and not governance_statuses
        )

        object_rows.append(
            {
                "object_id": object_id,
                "title": obj["title"],
                "object_type": obj["object_type"],
                "has_metadata": truthy(obj["has_metadata"]),
                "access_level": obj["access_level"],
                "status": obj["status"],
                "relationship_degree": degree[object_id],
                "is_orphan": degree[object_id] == 0,
                "governance_record_count": len(governance_statuses),
                "needs_stewardship_review": needs_review,
            }
        )

    write_csv(
        OUTPUTS / "institutional_object_diagnostics.csv",
        object_rows,
        [
            "object_id",
            "title",
            "object_type",
            "has_metadata",
            "access_level",
            "status",
            "relationship_degree",
            "is_orphan",
            "governance_record_count",
            "needs_stewardship_review",
        ],
    )

    write_csv(
        OUTPUTS / "institutional_relationship_type_summary.csv",
        [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
        ["relationship_type", "count"],
    )

    access_counts = Counter(obj["access_level"] for obj in objects)
    write_csv(
        OUTPUTS / "institutional_access_level_summary.csv",
        [{"access_level": key, "count": value} for key, value in access_counts.items()],
        ["access_level", "count"],
    )

    governance_status_counts = Counter(record["review_status"] for record in governance_records)
    write_csv(
        OUTPUTS / "governance_review_status_summary.csv",
        [{"review_status": key, "count": value} for key, value in governance_status_counts.items()],
        ["review_status", "count"],
    )

    stewardship_severity_counts = Counter(check["severity"] for check in stewardship_checks)
    write_csv(
        OUTPUTS / "stewardship_check_severity_summary.csv",
        [{"severity": key, "count": value} for key, value in stewardship_severity_counts.items()],
        ["severity", "count"],
    )

    object_count = len(objects)
    relationship_count = len(relationships)

    summary = {
        "object_count": object_count,
        "relationship_count": relationship_count,
        "metadata_coverage": round(sum(row["has_metadata"] for row in object_rows) / object_count, 3),
        "relationship_traceability": round(traceable / relationship_count, 3),
        "orphan_count": sum(row["is_orphan"] for row in object_rows),
        "stewardship_review_count": sum(row["needs_stewardship_review"] for row in object_rows),
        "relationship_type_count": len(relationship_types),
        "metadata_requirement_count": len(metadata_requirements),
        "governance_record_count": len(governance_records),
        "stewardship_check_count": len(stewardship_checks),
    }

    write_csv(
        OUTPUTS / "institutional_knowledge_system_summary.csv",
        [{"metric": key, "value": value} for key, value in summary.items()],
        ["metric", "value"],
    )

    print("Wrote institutional knowledge-system diagnostics to:", OUTPUTS)


if __name__ == "__main__":
    main()
