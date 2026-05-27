#!/usr/bin/env python3
"""
Framework network analysis for Conceptual Frameworks in Research.

This script treats a conceptual framework as a directed network of concepts and
relationships. It uses only Python's standard library so it can run in minimal
research environments.

Outputs:
- outputs/framework_concept_metrics.csv
- outputs/framework_relationship_type_summary.csv
- outputs/framework_audit_report.md
"""

from __future__ import annotations

from collections import Counter, defaultdict, deque
from dataclasses import dataclass
from pathlib import Path
import csv


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(parents=True, exist_ok=True)


@dataclass(frozen=True)
class Concept:
    concept_id: str
    label: str
    role: str
    domain: str
    evidence_status: str
    definition: str


@dataclass(frozen=True)
class Relationship:
    source_concept_id: str
    target_concept_id: str
    relationship_type: str
    assumption_note: str


def read_csv_dicts(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def reachable_nodes(start: str, adjacency: dict[str, list[str]]) -> set[str]:
    seen: set[str] = set()
    queue: deque[str] = deque([start])

    while queue:
        node = queue.popleft()
        for neighbor in adjacency.get(node, []):
            if neighbor not in seen:
                seen.add(neighbor)
                queue.append(neighbor)

    seen.discard(start)
    return seen


def main() -> None:
    concepts = [
        Concept(**row)
        for row in read_csv_dicts(DATA / "framework_concepts.csv")
    ]

    relationships = [
        Relationship(**row)
        for row in read_csv_dicts(DATA / "framework_relationships.csv")
    ]

    concept_ids = {concept.concept_id for concept in concepts}
    concept_by_id = {concept.concept_id: concept for concept in concepts}

    invalid_edges = [
        rel for rel in relationships
        if rel.source_concept_id not in concept_ids or rel.target_concept_id not in concept_ids
    ]

    if invalid_edges:
        raise ValueError(f"Invalid relationship references: {invalid_edges}")

    indegree: Counter[str] = Counter()
    outdegree: Counter[str] = Counter()
    relationship_types: Counter[str] = Counter()
    adjacency: defaultdict[str, list[str]] = defaultdict(list)

    for rel in relationships:
        outdegree[rel.source_concept_id] += 1
        indegree[rel.target_concept_id] += 1
        relationship_types[rel.relationship_type] += 1
        adjacency[rel.source_concept_id].append(rel.target_concept_id)

    metrics: list[dict[str, object]] = []

    for concept in concepts:
        inbound = indegree[concept.concept_id]
        outbound = outdegree[concept.concept_id]
        degree = inbound + outbound
        reach = len(reachable_nodes(concept.concept_id, adjacency))
        bridge_score = inbound * outbound

        metrics.append({
            "concept_id": concept.concept_id,
            "label": concept.label,
            "role": concept.role,
            "evidence_status": concept.evidence_status,
            "indegree": inbound,
            "outdegree": outbound,
            "degree": degree,
            "reachable_nodes": reach,
            "bridge_score": bridge_score,
        })

    metrics.sort(key=lambda row: (row["degree"], row["bridge_score"], row["reachable_nodes"]), reverse=True)

    write_csv(
        OUTPUTS / "framework_concept_metrics.csv",
        metrics,
        [
            "concept_id",
            "label",
            "role",
            "evidence_status",
            "indegree",
            "outdegree",
            "degree",
            "reachable_nodes",
            "bridge_score",
        ],
    )

    relationship_summary = [
        {"relationship_type": rel_type, "count": count}
        for rel_type, count in sorted(relationship_types.items())
    ]

    write_csv(
        OUTPUTS / "framework_relationship_type_summary.csv",
        relationship_summary,
        ["relationship_type", "count"],
    )

    evidence_status = Counter(concept.evidence_status for concept in concepts)
    roles = Counter(concept.role for concept in concepts)
    provisional = [concept for concept in concepts if concept.evidence_status != "supported"]

    report = [
        "# Conceptual Framework Audit Report",
        "",
        "## Overview",
        "",
        f"- Concepts: {len(concepts)}",
        f"- Relationships: {len(relationships)}",
        f"- Relationship types: {len(relationship_types)}",
        "",
        "## Evidence Status",
        "",
    ]

    for status, count in sorted(evidence_status.items()):
        report.append(f"- {status}: {count}")

    report.extend(["", "## Concept Roles", ""])

    for role, count in sorted(roles.items()):
        report.append(f"- {role}: {count}")

    report.extend(["", "## Provisional Concepts", ""])

    if provisional:
        for concept in provisional:
            report.append(f"- {concept.label} ({concept.role})")
    else:
        report.append("- None")

    report.extend(["", "## Top Concepts by Degree", ""])

    for row in metrics[:5]:
        report.append(
            f"- {row['label']}: degree={row['degree']}, "
            f"bridge_score={row['bridge_score']}, reachable_nodes={row['reachable_nodes']}"
        )

    (OUTPUTS / "framework_audit_report.md").write_text("\n".join(report) + "\n", encoding="utf-8")

    print("Wrote framework network outputs to:", OUTPUTS)


if __name__ == "__main__":
    main()
