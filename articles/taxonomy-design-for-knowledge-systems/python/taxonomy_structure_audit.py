"""
Taxonomy structure audit for knowledge systems.

This script reads small CSV files from ../data and generates diagnostics:
- depth and breadth summaries
- parent-child counts
- orphan or weakly integrated term checks
- relationship-type summaries
- assignment coverage for knowledge objects

No external dependencies are required.
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
OUTPUTS.mkdir(exist_ok=True)


@dataclass(frozen=True)
class Term:
    term_id: str
    preferred_label: str
    parent_id: str
    depth: int
    facet: str
    scope_note: str
    status: str


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    term_rows = read_csv(DATA / "taxonomy_terms.csv")
    relationship_rows = read_csv(DATA / "taxonomy_relationships.csv")
    object_rows = read_csv(DATA / "knowledge_objects.csv")
    assignment_rows = read_csv(DATA / "term_assignments.csv")

    terms = {
        row["term_id"]: Term(
            term_id=row["term_id"],
            preferred_label=row["preferred_label"],
            parent_id=row["parent_id"],
            depth=int(row["depth"]),
            facet=row["facet"],
            scope_note=row["scope_note"],
            status=row["status"],
        )
        for row in term_rows
    }

    children: dict[str, list[str]] = defaultdict(list)
    for term in terms.values():
        if term.parent_id:
            children[term.parent_id].append(term.term_id)

    roots = [term_id for term_id, term in terms.items() if not term.parent_id]

    # Recompute depth from parent-child relationships to compare with declared depth.
    computed_depth: dict[str, int] = {}
    queue: deque[tuple[str, int]] = deque((root, 0) for root in roots)
    while queue:
        term_id, depth = queue.popleft()
        computed_depth[term_id] = depth
        for child in children.get(term_id, []):
            queue.append((child, depth + 1))

    relationship_degree = Counter()
    relationship_type_count = Counter()
    for row in relationship_rows:
        relationship_degree[row["source_term_id"]] += 1
        relationship_degree[row["target_term_id"]] += 1
        relationship_type_count[row["relationship_type"]] += 1

    assignment_count_by_term = Counter(row["term_id"] for row in assignment_rows)
    assigned_objects = {row["object_id"] for row in assignment_rows}
    all_objects = {row["object_id"] for row in object_rows}

    diagnostics: list[dict[str, object]] = []
    for term_id, term in sorted(terms.items()):
        child_count = len(children.get(term_id, []))
        rel_degree = relationship_degree[term_id]
        assignment_count = assignment_count_by_term[term_id]
        integrated = bool(term.parent_id or child_count or rel_degree or assignment_count)
        diagnostics.append(
            {
                "term_id": term_id,
                "preferred_label": term.preferred_label,
                "parent_id": term.parent_id,
                "declared_depth": term.depth,
                "computed_depth": computed_depth.get(term_id, "missing"),
                "depth_mismatch": term.depth != computed_depth.get(term_id),
                "facet": term.facet,
                "child_count": child_count,
                "relationship_degree": rel_degree,
                "assignment_count": assignment_count,
                "weakly_integrated": not integrated,
                "has_scope_note": bool(term.scope_note.strip()),
                "status": term.status,
            }
        )

    write_csv(
        OUTPUTS / "taxonomy_node_diagnostics.csv",
        diagnostics,
        [
            "term_id",
            "preferred_label",
            "parent_id",
            "declared_depth",
            "computed_depth",
            "depth_mismatch",
            "facet",
            "child_count",
            "relationship_degree",
            "assignment_count",
            "weakly_integrated",
            "has_scope_note",
            "status",
        ],
    )

    depths = [term.depth for term in terms.values()]
    summary = {
        "term_count": len(terms),
        "root_count": len(roots),
        "max_depth": max(depths),
        "mean_depth": round(sum(depths) / len(depths), 3),
        "leaf_count": sum(1 for term_id in terms if not children.get(term_id)),
        "relationship_count": len(relationship_rows),
        "assigned_object_count": len(assigned_objects),
        "unassigned_object_count": len(all_objects - assigned_objects),
        "depth_mismatch_count": sum(1 for row in diagnostics if row["depth_mismatch"]),
        "missing_scope_note_count": sum(1 for row in diagnostics if not row["has_scope_note"]),
    }

    with (OUTPUTS / "taxonomy_quality_summary.json").open("w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2)

    write_csv(
        OUTPUTS / "relationship_type_summary.csv",
        [
            {"relationship_type": relationship_type, "count": count}
            for relationship_type, count in sorted(relationship_type_count.items())
        ],
        ["relationship_type", "count"],
    )

    print("Taxonomy audit complete.")
    print(json.dumps(summary, indent=2))


if __name__ == "__main__":
    main()
