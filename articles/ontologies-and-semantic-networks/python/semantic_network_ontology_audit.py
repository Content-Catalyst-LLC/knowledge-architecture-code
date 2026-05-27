#!/usr/bin/env python3
"""
Semantic network and ontology audit for the Ontologies and Semantic Networks article.

The script uses only the Python standard library. It reads synthetic node, edge,
class, property, and triple data; then generates degree diagnostics, relationship
summaries, orphan-node checks, DOT graph output, and a lightweight Turtle export.
"""

from __future__ import annotations

from collections import Counter, defaultdict
from pathlib import Path
import csv
import re

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(parents=True, exist_ok=True)

def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))

def slug(value: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9]+", "_", value.strip())
    cleaned = cleaned.strip("_")
    return cleaned or "unnamed"

nodes = read_csv(DATA / "nodes.csv")
edges = read_csv(DATA / "edges.csv")
classes = read_csv(DATA / "ontology_classes.csv")
properties = read_csv(DATA / "properties.csv")
triples = read_csv(DATA / "triples.csv")

node_by_id = {row["node_id"]: row for row in nodes}
degree: Counter[str] = Counter()
out_degree: Counter[str] = Counter()
in_degree: Counter[str] = Counter()
relationship_counts: Counter[str] = Counter()
undocumented_edges: list[dict[str, str]] = []

for edge in edges:
    source = edge["source"]
    target = edge["target"]
    rel = edge["relationship"]
    degree[source] += 1
    degree[target] += 1
    out_degree[source] += 1
    in_degree[target] += 1
    relationship_counts[rel] += 1
    if edge.get("documented", "").strip().lower() != "true":
        undocumented_edges.append(edge)

node_degrees = []
for node in nodes:
    node_id = node["node_id"]
    node_degrees.append({
        "node_id": node_id,
        "label": node["label"],
        "node_type": node["node_type"],
        "degree": degree[node_id],
        "in_degree": in_degree[node_id],
        "out_degree": out_degree[node_id],
        "is_orphan": degree[node_id] == 0,
    })

with (OUTPUTS / "semantic_network_node_degrees.csv").open("w", newline="", encoding="utf-8") as f:
    fieldnames = ["node_id", "label", "node_type", "degree", "in_degree", "out_degree", "is_orphan"]
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(sorted(node_degrees, key=lambda row: (-row["degree"], row["label"])))

with (OUTPUTS / "semantic_relationship_summary.csv").open("w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["relationship", "count"])
    for relationship, count in relationship_counts.most_common():
        writer.writerow([relationship, count])

summary = {
    "node_count": len(nodes),
    "edge_count": len(edges),
    "triple_count": len(triples),
    "class_count": len(classes),
    "property_count": len(properties),
    "orphan_count": sum(1 for row in node_degrees if row["is_orphan"]),
    "relationship_type_count": len(relationship_counts),
    "undocumented_edge_count": len(undocumented_edges),
    "density_directed_simple": round(len(edges) / (len(nodes) * (len(nodes) - 1)), 4) if len(nodes) > 1 else 0,
}

with (OUTPUTS / "semantic_network_quality_summary.csv").open("w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["metric", "value"])
    for key, value in summary.items():
        writer.writerow([key, value])

with (OUTPUTS / "semantic_network.dot").open("w", encoding="utf-8") as f:
    f.write("digraph SemanticNetwork {\n")
    f.write('  graph [rankdir="LR"];\n')
    for node in nodes:
        f.write(f'  {slug(node["node_id"])} [label="{node["label"]}\\n({node["node_type"]})"];\n')
    for edge in edges:
        f.write(f'  {slug(edge["source"])} -> {slug(edge["target"])} [label="{edge["relationship"]}"];\n')
    f.write("}\n")

with (OUTPUTS / "knowledge_architecture_semantic_network.ttl").open("w", encoding="utf-8") as f:
    f.write("@prefix ka: <https://sustainablecatalyst.com/ontology/knowledge-architecture#> .\n")
    f.write("@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n\n")

    for cls in classes:
        class_id = slug(cls["class_id"])
        f.write(f"ka:{class_id} a rdfs:Class ;\n")
        f.write(f'  rdfs:label "{cls["label"]}" ;\n')
        f.write(f'  rdfs:comment "{cls["definition"]}" .\n\n')

    for triple in triples:
        s = slug(triple["subject"])
        p = slug(triple["predicate"])
        o = slug(triple["object"])
        f.write(f"ka:{s} ka:{p} ka:{o} .\n")

print("Semantic-network ontology audit complete.")
print(f"Wrote outputs to: {OUTPUTS}")
