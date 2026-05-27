"""
Knowledge Graph Pipeline

Builds a lightweight, dependency-free knowledge graph diagnostic workflow from
CSV node, edge, relationship-type, and provenance tables.
"""

from __future__ import annotations

import csv
import json
from collections import Counter, defaultdict, deque
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(exist_ok=True)


@dataclass(frozen=True)
class Node:
    node_id: str
    label: str
    node_type: str
    description: str
    status: str


@dataclass(frozen=True)
class Edge:
    edge_id: str
    source_node_id: str
    relationship_type_id: str
    target_node_id: str
    confidence_level: str
    provenance_id: str


def read_csv_dicts(path: Path) -> List[Dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: Iterable[Dict[str, object]], fieldnames: List[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    nodes = [Node(**row) for row in read_csv_dicts(DATA / "nodes.csv")]
    edges = [Edge(**row) for row in read_csv_dicts(DATA / "edges.csv")]
    relationship_types = read_csv_dicts(DATA / "relationship_types.csv")
    evidence_sources = read_csv_dicts(DATA / "evidence_sources.csv")

    rules = json.loads((DATA / "validation_rules.json").read_text(encoding="utf-8"))
    node_ids = {node.node_id for node in nodes}
    relationship_type_ids = {row["relationship_type_id"] for row in relationship_types}
    provenance_ids = {row["provenance_id"] for row in evidence_sources}

    degree = defaultdict(int)
    out_degree = defaultdict(int)
    in_degree = defaultdict(int)
    relationship_counts = Counter()
    confidence_counts = Counter()
    warnings: List[Dict[str, str]] = []

    adjacency: Dict[str, List[str]] = defaultdict(list)

    for edge in edges:
        if edge.source_node_id not in node_ids:
            warnings.append({"level": "error", "message": f"Unknown source node: {edge.source_node_id}"})
        if edge.target_node_id not in node_ids:
            warnings.append({"level": "error", "message": f"Unknown target node: {edge.target_node_id}"})
        if edge.relationship_type_id not in relationship_type_ids:
            warnings.append({"level": "error", "message": f"Unknown relationship type: {edge.relationship_type_id}"})
        if edge.provenance_id not in provenance_ids:
            warnings.append({"level": "warning", "message": f"Missing provenance record: {edge.provenance_id}"})
        if edge.confidence_level not in rules["allowed_confidence_levels"]:
            warnings.append({"level": "warning", "message": f"Unexpected confidence level: {edge.confidence_level}"})

        degree[edge.source_node_id] += 1
        degree[edge.target_node_id] += 1
        out_degree[edge.source_node_id] += 1
        in_degree[edge.target_node_id] += 1
        relationship_counts[edge.relationship_type_id] += 1
        confidence_counts[edge.confidence_level] += 1
        adjacency[edge.source_node_id].append(edge.target_node_id)

    node_rows = []
    for node in nodes:
        node_rows.append({
            "node_id": node.node_id,
            "label": node.label,
            "node_type": node.node_type,
            "degree": degree[node.node_id],
            "in_degree": in_degree[node.node_id],
            "out_degree": out_degree[node.node_id],
            "is_orphan": degree[node.node_id] == 0,
            "status": node.status,
        })

    write_csv(
        OUTPUTS / "knowledge_graph_node_diagnostics.csv",
        node_rows,
        ["node_id", "label", "node_type", "degree", "in_degree", "out_degree", "is_orphan", "status"],
    )

    write_csv(
        OUTPUTS / "knowledge_graph_relationship_summary.csv",
        [
            {"relationship_type_id": key, "edge_count": value}
            for key, value in sorted(relationship_counts.items())
        ],
        ["relationship_type_id", "edge_count"],
    )

    provenance_coverage = sum(1 for edge in edges if edge.provenance_id) / len(edges) if edges else 0
    graph_density = len(edges) / (len(nodes) * (len(nodes) - 1)) if len(nodes) > 1 else 0
    orphan_count = sum(1 for row in node_rows if row["is_orphan"])

    summary = [
        {"metric": "node_count", "value": len(nodes)},
        {"metric": "edge_count", "value": len(edges)},
        {"metric": "relationship_type_count", "value": len(relationship_counts)},
        {"metric": "orphan_count", "value": orphan_count},
        {"metric": "provenance_coverage", "value": round(provenance_coverage, 3)},
        {"metric": "directed_graph_density", "value": round(graph_density, 3)},
        {"metric": "warning_count", "value": len(warnings)},
    ]

    write_csv(OUTPUTS / "knowledge_graph_quality_summary.csv", summary, ["metric", "value"])
    write_csv(OUTPUTS / "knowledge_graph_validation_warnings.csv", warnings, ["level", "message"])

    # Simple reachability from the article node.
    start = "kg_article"
    visited = set()
    queue = deque([start])
    while queue:
        current = queue.popleft()
        if current in visited:
            continue
        visited.add(current)
        queue.extend(adjacency[current])

    write_csv(
        OUTPUTS / "article_reachable_nodes.csv",
        [{"source": start, "reachable_node_id": node_id} for node_id in sorted(visited)],
        ["source", "reachable_node_id"],
    )

    print(f"Wrote diagnostics to {OUTPUTS}")


if __name__ == "__main__":
    main()
