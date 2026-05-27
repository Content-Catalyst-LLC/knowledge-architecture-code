"""
Knowledge Mapping and Conceptual Models
Professional lightweight diagnostics for concept maps, relationship coverage,
pathways, and evidence status.

Run from the article folder:
    python3 python/knowledge_mapping_conceptual_model.py
"""

from __future__ import annotations

from collections import Counter, defaultdict, deque
from dataclasses import dataclass
from pathlib import Path
import csv
import json
from typing import Dict, Iterable, List

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(parents=True, exist_ok=True)


@dataclass(frozen=True)
class Concept:
    concept_id: str
    label: str
    concept_type: str
    domain: str
    definition: str
    status: str


@dataclass(frozen=True)
class Relationship:
    source: str
    target: str
    relationship: str
    evidence_status: str
    provenance_note: str


def read_csv(path: Path) -> List[Dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: Iterable[Dict[str, object]], fieldnames: List[str]) -> None:
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def load_concepts() -> Dict[str, Concept]:
    rows = read_csv(DATA / "concepts.csv")
    return {
        row["concept_id"]: Concept(
            concept_id=row["concept_id"],
            label=row["label"],
            concept_type=row["concept_type"],
            domain=row["domain"],
            definition=row["definition"],
            status=row["status"],
        )
        for row in rows
    }


def load_relationships() -> List[Relationship]:
    rows = read_csv(DATA / "relationships.csv")
    return [
        Relationship(
            source=row["source"],
            target=row["target"],
            relationship=row["relationship"],
            evidence_status=row["evidence_status"],
            provenance_note=row["provenance_note"],
        )
        for row in rows
    ]


def validate_relationships(concepts: Dict[str, Concept], relationships: List[Relationship]) -> List[Dict[str, str]]:
    issues: List[Dict[str, str]] = []
    for rel in relationships:
        if rel.source not in concepts:
            issues.append({"severity": "error", "issue": "missing_source", "value": rel.source})
        if rel.target not in concepts:
            issues.append({"severity": "error", "issue": "missing_target", "value": rel.target})
        if not rel.relationship.strip():
            issues.append({"severity": "error", "issue": "empty_relationship_type", "value": f"{rel.source}->{rel.target}"})
        if rel.evidence_status not in {"documented", "provisional", "contested", "under_review"}:
            issues.append({"severity": "warning", "issue": "nonstandard_evidence_status", "value": rel.evidence_status})
    return issues


def shortest_path(start: str, goal: str, adjacency: Dict[str, List[str]]) -> List[str]:
    if start == goal:
        return [start]
    queue = deque([(start, [start])])
    visited = {start}
    while queue:
        node, path = queue.popleft()
        for neighbor in adjacency.get(node, []):
            if neighbor == goal:
                return path + [neighbor]
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append((neighbor, path + [neighbor]))
    return []


def main() -> None:
    concepts = load_concepts()
    relationships = load_relationships()
    issues = validate_relationships(concepts, relationships)

    degree = defaultdict(int)
    outgoing = defaultdict(int)
    incoming = defaultdict(int)
    adjacency = defaultdict(list)
    relationship_counts = Counter()
    evidence_counts = Counter()

    for rel in relationships:
        degree[rel.source] += 1
        degree[rel.target] += 1
        outgoing[rel.source] += 1
        incoming[rel.target] += 1
        adjacency[rel.source].append(rel.target)
        relationship_counts[rel.relationship] += 1
        evidence_counts[rel.evidence_status] += 1

    node_rows = []
    for concept_id, concept in sorted(concepts.items()):
        node_rows.append({
            "concept_id": concept_id,
            "label": concept.label,
            "concept_type": concept.concept_type,
            "domain": concept.domain,
            "degree": degree[concept_id],
            "in_degree": incoming[concept_id],
            "out_degree": outgoing[concept_id],
            "is_orphan": degree[concept_id] == 0,
        })

    write_csv(
        OUTPUTS / "knowledge_map_node_diagnostics.csv",
        node_rows,
        ["concept_id", "label", "concept_type", "domain", "degree", "in_degree", "out_degree", "is_orphan"],
    )

    write_csv(
        OUTPUTS / "relationship_type_summary.csv",
        [{"relationship": k, "count": v} for k, v in sorted(relationship_counts.items())],
        ["relationship", "count"],
    )

    write_csv(
        OUTPUTS / "evidence_status_summary.csv",
        [{"evidence_status": k, "count": v} for k, v in sorted(evidence_counts.items())],
        ["evidence_status", "count"],
    )

    issue_rows = issues or [{"severity": "ok", "issue": "none", "value": "all relationships validated"}]
    write_csv(OUTPUTS / "validation_issues.csv", issue_rows, ["severity", "issue", "value"])

    documented = evidence_counts["documented"]
    total_relationships = len(relationships)
    orphan_count = sum(1 for row in node_rows if row["is_orphan"])
    path = shortest_path("knowledge_mapping", "ai_retrieval", adjacency)

    summary = {
        "article_slug": "knowledge-mapping-and-conceptual-models",
        "concept_count": len(concepts),
        "relationship_count": total_relationships,
        "relationship_type_count": len(relationship_counts),
        "orphan_count": orphan_count,
        "evidence_coverage": round(documented / total_relationships, 3) if total_relationships else 0,
        "path_knowledge_mapping_to_ai_retrieval": path,
        "validation_issue_count": len(issues),
    }

    with (OUTPUTS / "knowledge_map_summary.json").open("w", encoding="utf-8") as f:
        json.dump(summary, f, indent=2)

    with (OUTPUTS / "knowledge_map_summary.csv").open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["metric", "value"])
        for key, value in summary.items():
            writer.writerow([key, json.dumps(value) if isinstance(value, list) else value])

    print("Wrote knowledge mapping diagnostics to outputs/")


if __name__ == "__main__":
    main()
