#!/usr/bin/env python3
"""
Complex Systems Conceptual Model Audit

Audits a synthetic complex-systems conceptual model for:
- component metadata coverage
- uncertainty-context coverage
- relationship traceability
- feedback edge share
- underspecified relationship risk
- scale distribution
- feedback-loop inventory
- assumption sensitivity
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


systems = read_csv(DATA / "systems.csv")
components = read_csv(DATA / "components.csv")
relationships = read_csv(DATA / "relationships.csv")
feedback_loops = read_csv(DATA / "feedback_loops.csv")
assumptions = read_csv(DATA / "assumptions.csv")
evidence_records = read_csv(DATA / "evidence_records.csv")
governance_checks = read_csv(DATA / "governance_checks.csv")

degree = defaultdict(int)
relationship_types = Counter()
traceable = 0
feedback_edges = 0
underspecified = 0

for rel in relationships:
    degree[rel["source_component_id"]] += 1
    degree[rel["target_component_id"]] += 1
    relationship_types[rel["relationship_type"]] += 1
    if rel["provenance_note"].strip():
        traceable += 1
    if truthy(rel["feedback_relevant"]):
        feedback_edges += 1
    if rel["relationship_type"] in {"related", "sameAs", ""}:
        underspecified += 1

component_rows = []
for component in components:
    component_id = component["component_id"]
    has_metadata = truthy(component["has_metadata"])
    has_uncertainty_context = truthy(component["has_uncertainty_context"])
    is_orphan = degree[component_id] == 0
    needs_review = (
        not has_metadata
        or component["status"] == "review_needed"
        or is_orphan
    )
    component_rows.append(
        {
            "component_id": component_id,
            "system_id": component["system_id"],
            "label": component["label"],
            "component_type": component["component_type"],
            "has_metadata": has_metadata,
            "scale": component["scale"],
            "has_uncertainty_context": has_uncertainty_context,
            "status": component["status"],
            "relationship_degree": degree[component_id],
            "is_orphan": is_orphan,
            "needs_review": needs_review,
        }
    )

write_csv(
    OUTPUTS / "complex_system_component_diagnostics.csv",
    component_rows,
    [
        "component_id",
        "system_id",
        "label",
        "component_type",
        "has_metadata",
        "scale",
        "has_uncertainty_context",
        "status",
        "relationship_degree",
        "is_orphan",
        "needs_review",
    ],
)

write_csv(
    OUTPUTS / "complex_system_relationship_type_summary.csv",
    [{"relationship_type": key, "count": value} for key, value in relationship_types.items()],
    ["relationship_type", "count"],
)

component_type_counts = Counter(component["component_type"] for component in components)
write_csv(
    OUTPUTS / "complex_system_component_type_summary.csv",
    [{"component_type": key, "count": value} for key, value in component_type_counts.items()],
    ["component_type", "count"],
)

scale_counts = Counter(component["scale"] for component in components)
write_csv(
    OUTPUTS / "complex_system_scale_summary.csv",
    [{"scale": key, "count": value} for key, value in scale_counts.items()],
    ["scale", "count"],
)

loop_type_counts = Counter(loop["loop_type"] for loop in feedback_loops)
write_csv(
    OUTPUTS / "complex_system_feedback_loop_summary.csv",
    [{"loop_type": key, "count": value} for key, value in loop_type_counts.items()],
    ["loop_type", "count"],
)

assumption_sensitivity_counts = Counter(assumption["sensitivity_level"] for assumption in assumptions)
write_csv(
    OUTPUTS / "complex_system_assumption_sensitivity_summary.csv",
    [{"sensitivity_level": key, "count": value} for key, value in assumption_sensitivity_counts.items()],
    ["sensitivity_level", "count"],
)

evidence_type_counts = Counter(evidence["evidence_type"] for evidence in evidence_records)
write_csv(
    OUTPUTS / "complex_system_evidence_type_summary.csv",
    [{"evidence_type": key, "count": value} for key, value in evidence_type_counts.items()],
    ["evidence_type", "count"],
)

governance_severity_counts = Counter(check["severity"] for check in governance_checks)
write_csv(
    OUTPUTS / "complex_system_governance_severity_summary.csv",
    [{"severity": key, "count": value} for key, value in governance_severity_counts.items()],
    ["severity", "count"],
)

summary = {
    "system_count": len(systems),
    "component_count": len(components),
    "relationship_count": len(relationships),
    "feedback_loop_count": len(feedback_loops),
    "assumption_count": len(assumptions),
    "evidence_record_count": len(evidence_records),
    "metadata_coverage": round(sum(row["has_metadata"] for row in component_rows) / len(components), 3),
    "uncertainty_context_coverage": round(sum(row["has_uncertainty_context"] for row in component_rows) / len(components), 3),
    "relationship_traceability": round(traceable / len(relationships), 3),
    "feedback_edge_share": round(feedback_edges / len(relationships), 3),
    "underspecified_relationship_risk": round(underspecified / len(relationships), 3),
    "orphan_count": sum(row["is_orphan"] for row in component_rows),
    "review_needed_count": sum(row["needs_review"] for row in component_rows),
    "relationship_type_count": len(relationship_types),
    "scale_count": len(scale_counts),
    "governance_check_count": len(governance_checks),
}

with (OUTPUTS / "complex_system_conceptual_model_summary.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.writer(handle)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

print("Wrote complex systems conceptual model diagnostics to:", OUTPUTS)
