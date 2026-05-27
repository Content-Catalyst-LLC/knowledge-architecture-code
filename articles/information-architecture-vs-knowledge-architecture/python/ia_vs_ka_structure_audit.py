#!/usr/bin/env python3
"""
IA vs KA structure audit.

Compares visible navigation links with semantic relationships to identify:
- objects that are navigable but semantically thin
- objects that are semantically important but weakly visible
- objects missing metadata context
- relationship type distributions
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
    objects = read_csv(DATA / "information_objects.csv")
    navigation_links = read_csv(DATA / "navigation_links.csv")
    semantic_relationships = read_csv(DATA / "semantic_relationships.csv")

    nav_degree = defaultdict(int)
    semantic_degree = defaultdict(int)
    nav_types = Counter()
    relationship_types = Counter()

    for link in navigation_links:
        nav_degree[link["source_object_id"]] += 1
        nav_degree[link["target_object_id"]] += 1
        nav_types[link["navigation_type"]] += 1

    for rel in semantic_relationships:
        semantic_degree[rel["source_object_id"]] += 1
        semantic_degree[rel["target_object_id"]] += 1
        relationship_types[rel["relationship_type"]] += 1

    alignment_rows = []
    for obj in objects:
        object_id = obj["object_id"]
        navigation = nav_degree[object_id]
        semantic = semantic_degree[object_id]
        has_metadata = truthy(obj["has_metadata_context"])

        issue = ""
        if navigation > 0 and semantic == 0:
            issue = "Navigable but semantically underdeveloped"
        elif semantic > 0 and navigation == 0:
            issue = "Semantically connected but weakly visible in navigation"
        elif not has_metadata:
            issue = "Missing metadata context"
        elif navigation == 0 and semantic == 0:
            issue = "Isolated object"

        alignment_rows.append(
            {
                "object_id": object_id,
                "title": obj["title"],
                "object_type": obj["object_type"],
                "navigation_degree": navigation,
                "semantic_degree": semantic,
                "has_metadata_context": has_metadata,
                "alignment_issue": issue,
            }
        )

    write_csv(
        OUTPUTS / "ia_ka_alignment_audit.csv",
        alignment_rows,
        [
            "object_id",
            "title",
            "object_type",
            "navigation_degree",
            "semantic_degree",
            "has_metadata_context",
            "alignment_issue",
        ],
    )

    write_csv(
        OUTPUTS / "navigation_type_summary.csv",
        [{"navigation_type": key, "count": value} for key, value in nav_types.items()],
        ["navigation_type", "count"],
    )

    write_csv(
        OUTPUTS / "semantic_relationship_summary.csv",
        [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
        ["relationship_type", "count"],
    )

    summary = {
        "object_count": len(objects),
        "navigation_link_count": len(navigation_links),
        "semantic_relationship_count": len(semantic_relationships),
        "metadata_context_coverage": round(
            sum(truthy(obj["has_metadata_context"]) for obj in objects) / len(objects), 3
        ),
        "objects_with_alignment_issues": sum(1 for row in alignment_rows if row["alignment_issue"]),
    }

    write_csv(
        OUTPUTS / "ia_ka_summary.csv",
        [{"metric": key, "value": value} for key, value in summary.items()],
        ["metric", "value"],
    )

    print("Wrote IA/KA audit outputs to:", OUTPUTS)


if __name__ == "__main__":
    main()
