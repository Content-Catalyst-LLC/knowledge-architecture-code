#!/usr/bin/env python3
"""
Hierarchy audit workflow for knowledge architecture.

This script reads a node table and an edge table, validates a hierarchy-like
knowledge structure, and writes diagnostics for editorial and repository review.

No external dependencies are required.
"""

from __future__ import annotations

import csv
from collections import defaultdict, deque
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Set, Tuple


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(parents=True, exist_ok=True)


@dataclass(frozen=True)
class Node:
    node_id: str
    label: str
    node_type: str
    domain: str
    status: str


@dataclass(frozen=True)
class Edge:
    parent_id: str
    child_id: str
    relationship_type: str
    sort_order: int


def read_nodes(path: Path) -> Dict[str, Node]:
    with path.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        return {
            row["node_id"]: Node(
                node_id=row["node_id"],
                label=row["label"],
                node_type=row.get("node_type", ""),
                domain=row.get("domain", ""),
                status=row.get("status", ""),
            )
            for row in reader
        }


def read_edges(path: Path) -> List[Edge]:
    edges: List[Edge] = []
    with path.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        for row in reader:
            edges.append(
                Edge(
                    parent_id=row["parent_id"],
                    child_id=row["child_id"],
                    relationship_type=row.get("relationship_type", "broader_narrower"),
                    sort_order=int(row.get("sort_order", 0) or 0),
                )
            )
    return edges


def build_maps(edges: Iterable[Edge]) -> Tuple[Dict[str, List[str]], Dict[str, List[str]]]:
    children: Dict[str, List[str]] = defaultdict(list)
    parents: Dict[str, List[str]] = defaultdict(list)

    for edge in edges:
        children[edge.parent_id].append(edge.child_id)
        parents[edge.child_id].append(edge.parent_id)

    return children, parents


def find_roots(nodes: Dict[str, Node], parents: Dict[str, List[str]]) -> List[str]:
    return sorted([node_id for node_id in nodes if len(parents[node_id]) == 0])


def compute_depths(roots: List[str], children: Dict[str, List[str]]) -> Dict[str, int]:
    depths: Dict[str, int] = {}
    queue: deque[Tuple[str, int]] = deque((root, 0) for root in roots)

    while queue:
        node_id, depth = queue.popleft()

        # Preserve the shortest depth when polyhierarchy exists.
        if node_id in depths and depths[node_id] <= depth:
            continue

        depths[node_id] = depth

        for child_id in children[node_id]:
            queue.append((child_id, depth + 1))

    return depths


def detect_missing_references(nodes: Dict[str, Node], edges: Iterable[Edge]) -> List[Dict[str, str]]:
    missing: List[Dict[str, str]] = []

    for edge in edges:
        if edge.parent_id not in nodes:
            missing.append({"missing_id": edge.parent_id, "role": "parent", "child_id": edge.child_id})
        if edge.child_id not in nodes:
            missing.append({"missing_id": edge.child_id, "role": "child", "parent_id": edge.parent_id})

    return missing


def detect_cycles(nodes: Dict[str, Node], children: Dict[str, List[str]]) -> List[str]:
    visiting: Set[str] = set()
    visited: Set[str] = set()
    cycle_nodes: Set[str] = set()

    def visit(node_id: str) -> None:
        if node_id in visiting:
            cycle_nodes.add(node_id)
            return
        if node_id in visited:
            return

        visiting.add(node_id)
        for child_id in children[node_id]:
            visit(child_id)
        visiting.remove(node_id)
        visited.add(node_id)

    for node_id in nodes:
        visit(node_id)

    return sorted(cycle_nodes)


def write_csv(path: Path, rows: List[Dict[str, object]], fieldnames: List[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    nodes = read_nodes(DATA / "hierarchy_nodes.csv")
    edges = read_edges(DATA / "hierarchy_edges.csv")

    children, parents = build_maps(edges)
    roots = find_roots(nodes, parents)
    depths = compute_depths(roots, children)

    missing_references = detect_missing_references(nodes, edges)
    cycle_nodes = detect_cycles(nodes, children)

    diagnostics: List[Dict[str, object]] = []
    for node_id, node in sorted(nodes.items()):
        parent_count = len(parents[node_id])
        child_count = len(children[node_id])
        diagnostics.append(
            {
                "node_id": node_id,
                "label": node.label,
                "node_type": node.node_type,
                "domain": node.domain,
                "status": node.status,
                "depth": depths.get(node_id, ""),
                "parent_count": parent_count,
                "child_count": child_count,
                "is_root": parent_count == 0,
                "is_leaf": child_count == 0,
                "is_polyhierarchical": parent_count > 1,
            }
        )

    level_counts: Dict[int, int] = defaultdict(int)
    for depth in depths.values():
        level_counts[depth] += 1

    summary = [
        {"metric": "node_count", "value": len(nodes)},
        {"metric": "edge_count", "value": len(edges)},
        {"metric": "root_count", "value": len(roots)},
        {"metric": "max_depth", "value": max(depths.values()) if depths else 0},
        {"metric": "leaf_count", "value": sum(1 for row in diagnostics if row["is_leaf"])},
        {"metric": "missing_reference_count", "value": len(missing_references)},
        {"metric": "cycle_node_count", "value": len(cycle_nodes)},
        {"metric": "polyhierarchical_node_count", "value": sum(1 for row in diagnostics if row["is_polyhierarchical"])},
    ]

    level_rows = [
        {"depth": depth, "node_count": count}
        for depth, count in sorted(level_counts.items())
    ]

    write_csv(
        OUTPUTS / "hierarchy_node_diagnostics.csv",
        diagnostics,
        [
            "node_id",
            "label",
            "node_type",
            "domain",
            "status",
            "depth",
            "parent_count",
            "child_count",
            "is_root",
            "is_leaf",
            "is_polyhierarchical",
        ],
    )

    write_csv(OUTPUTS / "hierarchy_level_counts.csv", level_rows, ["depth", "node_count"])
    write_csv(OUTPUTS / "hierarchy_summary.csv", summary, ["metric", "value"])

    if missing_references:
        write_csv(
            OUTPUTS / "hierarchy_missing_references.csv",
            missing_references,
            sorted({key for row in missing_references for key in row.keys()}),
        )

    if cycle_nodes:
        write_csv(
            OUTPUTS / "hierarchy_cycle_nodes.csv",
            [{"node_id": node_id} for node_id in cycle_nodes],
            ["node_id"],
        )

    print(f"Wrote hierarchy diagnostics to {OUTPUTS}")


if __name__ == "__main__":
    main()
