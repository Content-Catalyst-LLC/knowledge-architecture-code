#!/usr/bin/env python3
"""
What Is Knowledge Architecture?
Concept graph, degree metrics, relationship summaries, and pathway diagnostics.

This script is dependency-light and runs with the Python standard library.
"""

from __future__ import annotations

from collections import Counter, defaultdict, deque
from dataclasses import dataclass
from pathlib import Path
import csv
import json


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(parents=True, exist_ok=True)


@dataclass(frozen=True)
class Concept:
    concept_id: str
    label: str
    domain: str
    depth: int
    status: str


@dataclass(frozen=True)
class Relationship:
    source: str
    target: str
    relationship_type: str
    evidence_note: str


def read_concepts(path: Path) -> list[Concept]:
    with path.open(newline="", encoding="utf-8") as f:
        rows = csv.DictReader(f)
        return [
            Concept(
                concept_id=row["concept_id"],
                label=row["label"],
                domain=row["domain"],
                depth=int(row["depth"]),
                status=row["status"],
            )
            for row in rows
        ]


def read_relationships(path: Path) -> list[Relationship]:
    with path.open(newline="", encoding="utf-8") as f:
        rows = csv.DictReader(f)
        return [
            Relationship(
                source=row["source"],
                target=row["target"],
                relationship_type=row["relationship_type"],
                evidence_note=row["evidence_note"],
            )
            for row in rows
        ]


def build_undirected_adjacency(relationships: list[Relationship]) -> dict[str, set[str]]:
    adjacency: dict[str, set[str]] = defaultdict(set)
    for rel in relationships:
        adjacency[rel.source].add(rel.target)
        adjacency[rel.target].add(rel.source)
    return adjacency


def shortest_path(adjacency: dict[str, set[str]], source: str, target: str) -> list[str] | None:
    queue = deque([(source, [source])])
    visited = {source}

    while queue:
        node, path = queue.popleft()

        if node == target:
            return path

        for neighbor in sorted(adjacency.get(node, set())):
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, path + [neighbor]))

    return None


def main() -> None:
    concepts = read_concepts(DATA / "concepts.csv")
    relationships = read_relationships(DATA / "relationships.csv")

    degree = Counter()
    in_degree = Counter()
    out_degree = Counter()

    for concept in concepts:
        degree[concept.label] += 0
        in_degree[concept.label] += 0
        out_degree[concept.label] += 0

    for rel in relationships:
        degree[rel.source] += 1
        degree[rel.target] += 1
        out_degree[rel.source] += 1
        in_degree[rel.target] += 1

    relationship_types = Counter(rel.relationship_type for rel in relationships)
    domains = Counter(concept.domain for concept in concepts)

    metrics_path = OUTPUTS / "concept_degree_metrics.csv"
    with metrics_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["concept", "domain", "depth", "degree", "in_degree", "out_degree"])
        domain_lookup = {concept.label: concept.domain for concept in concepts}
        depth_lookup = {concept.label: concept.depth for concept in concepts}

        for concept, value in sorted(degree.items(), key=lambda item: (-item[1], item[0])):
            writer.writerow([
                concept,
                domain_lookup.get(concept, "unknown"),
                depth_lookup.get(concept, ""),
                value,
                in_degree[concept],
                out_degree[concept],
            ])

    type_path = OUTPUTS / "relationship_type_summary.csv"
    with type_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["relationship_type", "count"])
        for rel_type, count in sorted(relationship_types.items()):
            writer.writerow([rel_type, count])

    domain_path = OUTPUTS / "domain_summary.csv"
    with domain_path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["domain", "concept_count"])
        for domain, count in sorted(domains.items()):
            writer.writerow([domain, count])

    adjacency = build_undirected_adjacency(relationships)
    path = shortest_path(adjacency, "Taxonomy Design", "AI-Assisted Retrieval")

    summary = {
        "article": "What Is Knowledge Architecture?",
        "concept_count": len(concepts),
        "relationship_count": len(relationships),
        "relationship_types": dict(sorted(relationship_types.items())),
        "domains": dict(sorted(domains.items())),
        "sample_path_taxonomy_to_ai": path,
    }

    summary_path = OUTPUTS / "architecture_summary.json"
    summary_path.write_text(json.dumps(summary, indent=2), encoding="utf-8")

    print(f"Wrote {metrics_path}")
    print(f"Wrote {type_path}")
    print(f"Wrote {domain_path}")
    print(f"Wrote {summary_path}")


if __name__ == "__main__":
    main()
