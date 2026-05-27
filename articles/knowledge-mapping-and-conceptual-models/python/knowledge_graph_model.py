"""Minimal knowledge-graph model for article-level knowledge architecture.

Run from the article folder:
    python python/knowledge_graph_model.py
"""

from pathlib import Path
import csv
from collections import defaultdict

ROOT = Path(__file__).resolve().parents[1]
relationships_path = ROOT / "data" / "synthetic" / "relationships.csv"
output_dir = ROOT / "outputs" / "tables"
output_dir.mkdir(parents=True, exist_ok=True)

nodes = set()
degree = defaultdict(int)

with relationships_path.open(newline="", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        source = row["source"]
        target = row["target"]
        nodes.add(source)
        nodes.add(target)
        degree[source] += 1
        degree[target] += 1

metrics_path = output_dir / "article_graph_degree_metrics.csv"
with metrics_path.open("w", newline="", encoding="utf-8") as f:
    writer = csv.writer(f)
    writer.writerow(["node", "degree"])
    for node in sorted(nodes):
        writer.writerow([node, degree[node]])

print(f"Wrote {metrics_path}")
