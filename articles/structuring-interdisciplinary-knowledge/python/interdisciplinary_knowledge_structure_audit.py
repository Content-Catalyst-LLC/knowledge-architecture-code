#!/usr/bin/env python3
"""
Interdisciplinary Knowledge Structure Audit

Audits a synthetic interdisciplinary knowledge model for:
- concept scope-note coverage
- method-context coverage
- crosswalk traceability
- false-equivalence risk
- orphan concepts
- discipline distribution
- review needs
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


concepts = read_csv(DATA / "concepts.csv")
crosswalks = read_csv(DATA / "concept_crosswalks.csv")
methods = read_csv(DATA / "methods.csv")
evidence_types = read_csv(DATA / "evidence_types.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0
underspecified = 0

for rel in crosswalks:
    degree[rel["source_concept_id"]] += 1
    degree[rel["target_concept_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1
    if rel["relationship_type"] in {"related", "sameAs", ""}:
        underspecified += 1

concept_rows = []
for concept in concepts:
    concept_id = concept["concept_id"]
    has_scope_note = truthy(concept["has_scope_note"])
    has_method_context = truthy(concept["has_method_context"])
    is_orphan = degree[concept_id] == 0
    needs_review = (
        not has_scope_note
        or not has_method_context
        or is_orphan
        or concept["status"] == "review_needed"
    )
    concept_rows.append(
        {
            "concept_id": concept_id,
            "preferred_label": concept["preferred_label"],
            "discipline_id": concept["discipline_id"],
            "has_scope_note": has_scope_note,
            "has_method_context": has_method_context,
            "status": concept["status"],
            "crosswalk_degree": degree[concept_id],
            "is_orphan": is_orphan,
            "needs_review": needs_review,
        }
    )

write_csv(
    OUTPUTS / "interdisciplinary_concept_diagnostics.csv",
    concept_rows,
    [
        "concept_id",
        "preferred_label",
        "discipline_id",
        "has_scope_note",
        "has_method_context",
        "status",
        "crosswalk_degree",
        "is_orphan",
        "needs_review",
    ],
)

write_csv(
    OUTPUTS / "interdisciplinary_crosswalk_type_summary.csv",
    [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
    ["relationship_type", "count"],
)

discipline_counts = Counter(concept["discipline_id"] for concept in concepts)
write_csv(
    OUTPUTS / "interdisciplinary_discipline_summary.csv",
    [{"discipline_id": key, "concept_count": value} for key, value in discipline_counts.items()],
    ["discipline_id", "concept_count"],
)

method_type_counts = Counter(method["method_type"] for method in methods)
write_csv(
    OUTPUTS / "interdisciplinary_method_type_summary.csv",
    [{"method_type": key, "count": value} for key, value in method_type_counts.items()],
    ["method_type", "count"],
)

governance_severity_counts = Counter(check["severity"] for check in governance_checks)
write_csv(
    OUTPUTS / "interdisciplinary_governance_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

summary = {
    "concept_count": len(concepts),
    "crosswalk_count": len(crosswalks),
    "discipline_count": len(discipline_counts),
    "method_count": len(methods),
    "evidence_type_count": len(evidence_types),
    "scope_note_coverage": round(sum(row["has_scope_note"] for row in concept_rows) / len(concepts), 3),
    "method_context_coverage": round(sum(row["has_method_context"] for row in concept_rows) / len(concepts), 3),
    "relationship_traceability": round(traceable / len(crosswalks), 3),
    "false_equivalence_risk": round(underspecified / len(crosswalks), 3),
    "orphan_count": sum(row["is_orphan"] for row in concept_rows),
    "review_needed_count": sum(row["needs_review"] for row in concept_rows),
    "relationship_type_count": len(relationship_types),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "interdisciplinary_structure_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote interdisciplinary knowledge structure diagnostics to:", OUTPUTS)
