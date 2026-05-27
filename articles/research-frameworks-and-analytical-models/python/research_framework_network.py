"""
Research Framework Network Model

Models a research framework as a directed relationship network using only
Python's standard library. The script reads synthetic model elements and
relationships, then writes degree, role, and coherence summaries.
"""

from __future__ import annotations

from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(parents=True, exist_ok=True)


@dataclass(frozen=True)
class Element:
    element_id: str
    label: str
    role: str
    evidence_status: str
    definition: str


@dataclass(frozen=True)
class Relationship:
    source_id: str
    target_id: str
    relationship_type: str
    documented: bool
    assumption_note: str


def read_csv_dicts(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def load_elements() -> dict[str, Element]:
    rows = read_csv_dicts(DATA / "model_elements.csv")
    return {
        row["element_id"]: Element(
            element_id=row["element_id"],
            label=row["label"],
            role=row["role"],
            evidence_status=row["evidence_status"],
            definition=row["definition"],
        )
        for row in rows
    }


def load_relationships() -> list[Relationship]:
    rows = read_csv_dicts(DATA / "model_relationships.csv")
    return [
        Relationship(
            source_id=row["source_id"],
            target_id=row["target_id"],
            relationship_type=row["relationship_type"],
            documented=row["documented"].strip().lower() == "true",
            assumption_note=row["assumption_note"],
        )
        for row in rows
    ]


def main() -> None:
    elements = load_elements()
    relationships = load_relationships()

    degree: dict[str, int] = defaultdict(int)
    outgoing: dict[str, int] = defaultdict(int)
    incoming: dict[str, int] = defaultdict(int)

    for rel in relationships:
        degree[rel.source_id] += 1
        degree[rel.target_id] += 1
        outgoing[rel.source_id] += 1
        incoming[rel.target_id] += 1

    documented_count = sum(1 for rel in relationships if rel.documented)
    relationship_count = len(relationships)
    coherence_rate = documented_count / relationship_count if relationship_count else 0.0

    role_counts = Counter(element.role for element in elements.values())
    evidence_counts = Counter(element.evidence_status for element in elements.values())

    with (OUTPUTS / "research_framework_degree_summary.csv").open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["element_id", "label", "role", "degree", "incoming", "outgoing", "evidence_status"])
        for element_id, element in sorted(elements.items(), key=lambda item: degree[item[0]], reverse=True):
            writer.writerow([
                element_id,
                element.label,
                element.role,
                degree[element_id],
                incoming[element_id],
                outgoing[element_id],
                element.evidence_status,
            ])

    with (OUTPUTS / "research_framework_quality_summary.csv").open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["metric", "value"])
        writer.writerow(["element_count", len(elements)])
        writer.writerow(["relationship_count", relationship_count])
        writer.writerow(["documented_relationships", documented_count])
        writer.writerow(["relationship_coherence_rate", round(coherence_rate, 4)])
        writer.writerow(["underdeveloped_elements", evidence_counts.get("underdeveloped", 0)])
        writer.writerow(["provisional_elements", evidence_counts.get("provisional", 0)])

    with (OUTPUTS / "research_framework_role_summary.csv").open("w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow(["role", "element_count"])
        for role, count in sorted(role_counts.items()):
            writer.writerow([role, count])

    print("Wrote framework outputs to:", OUTPUTS)


if __name__ == "__main__":
    main()
