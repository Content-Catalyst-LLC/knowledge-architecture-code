"""
Framework Quality Audit

Checks for underdeveloped elements, undocumented relationships, and
unlinked methods/evidence records in the synthetic article data.
"""

from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(parents=True, exist_ok=True)


def rows(name: str) -> list[dict[str, str]]:
    with (DATA / name).open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


elements = rows("model_elements.csv")
relationships = rows("model_relationships.csv")
methods = rows("methods.csv")
sources = rows("evidence_sources.csv")

issues: list[tuple[str, str, str]] = []

for element in elements:
    if element["evidence_status"] in {"underdeveloped", "provisional"}:
        issues.append(("element_status", element["element_id"], element["evidence_status"]))
    if not element["definition"].strip():
        issues.append(("missing_definition", element["element_id"], "definition is empty"))

for idx, rel in enumerate(relationships, start=1):
    if rel["documented"].strip().lower() != "true":
        issues.append(("undocumented_relationship", f"relationship_{idx}", rel["relationship_type"]))
    if not rel["assumption_note"].strip():
        issues.append(("missing_assumption_note", f"relationship_{idx}", rel["relationship_type"]))

if not methods:
    issues.append(("missing_methods", "methods.csv", "no methods listed"))

if not sources:
    issues.append(("missing_sources", "evidence_sources.csv", "no evidence sources listed"))

with (OUTPUTS / "framework_quality_issues.csv").open("w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["issue_type", "object_id", "detail"])
    writer.writerows(issues)

print(f"Wrote {len(issues)} quality issues to outputs/framework_quality_issues.csv")
