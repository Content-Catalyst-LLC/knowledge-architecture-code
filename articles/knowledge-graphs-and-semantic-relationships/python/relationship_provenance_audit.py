"""
Relationship Provenance Audit

Checks whether every edge has a provenance record and creates a compact audit table.
"""

from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(exist_ok=True)


def rows(path: Path):
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


edges = rows(DATA / "edges.csv")
evidence = {row["provenance_id"]: row for row in rows(DATA / "evidence_sources.csv")}

out = []
for edge in edges:
    provenance_id = edge.get("provenance_id", "")
    match = evidence.get(provenance_id)
    out.append({
        "edge_id": edge["edge_id"],
        "relationship_type_id": edge["relationship_type_id"],
        "provenance_id": provenance_id,
        "has_provenance_record": bool(match),
        "source_type": match["source_type"] if match else "",
    })

with (OUTPUTS / "edge_provenance_audit.csv").open("w", newline="", encoding="utf-8") as handle:
    writer = csv.DictWriter(
        handle,
        fieldnames=["edge_id", "relationship_type_id", "provenance_id", "has_provenance_record", "source_type"],
    )
    writer.writeheader()
    writer.writerows(out)

print("Wrote outputs/edge_provenance_audit.csv")
