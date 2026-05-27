"""
Advanced knowledge architecture graph analysis.

This script reads concept and relationship tables, builds a directed graph,
calculates diagnostics, identifies likely bridge concepts and orphan concepts,
and exports reproducible tables.

Install optional dependencies from this directory:
    python -m pip install -r requirements.txt

Run from the article folder:
    python python/knowledge_architecture_graph_analysis.py
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import json

import networkx as nx
import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUTPUTS = ROOT / "outputs"
OUTPUTS.mkdir(parents=True, exist_ok=True)


@dataclass(frozen=True)
class ArchitectureConfig:
    concepts_file: Path = DATA / "concepts.csv"
    relationships_file: Path = DATA / "relationships.csv"
    metrics_file: Path = OUTPUTS / "concept_graph_metrics.csv"
    summary_file: Path = OUTPUTS / "architecture_summary.json"
    pathways_file: Path = OUTPUTS / "conceptual_pathways.csv"


def load_inputs(config: ArchitectureConfig) -> tuple[pd.DataFrame, pd.DataFrame]:
    concepts = pd.read_csv(config.concepts_file)
    relationships = pd.read_csv(config.relationships_file)

    required_concept_cols = {"concept_id", "label", "domain", "depth", "status"}
    required_relationship_cols = {"source", "target", "relationship", "weight"}

    missing_concepts = required_concept_cols.difference(concepts.columns)
    missing_relationships = required_relationship_cols.difference(relationships.columns)

    if missing_concepts:
        raise ValueError(f"Concept table missing columns: {sorted(missing_concepts)}")
    if missing_relationships:
        raise ValueError(f"Relationship table missing columns: {sorted(missing_relationships)}")

    return concepts, relationships


def build_graph(concepts: pd.DataFrame, relationships: pd.DataFrame) -> nx.DiGraph:
    graph = nx.DiGraph()

    for row in concepts.to_dict(orient="records"):
        graph.add_node(
            row["label"],
            concept_id=row["concept_id"],
            domain=row["domain"],
            depth=int(row["depth"]),
            status=row["status"],
        )

    for row in relationships.to_dict(orient="records"):
        graph.add_edge(
            row["source"],
            row["target"],
            relationship=row["relationship"],
            weight=float(row["weight"]),
        )

    return graph


def graph_metrics(graph: nx.DiGraph) -> pd.DataFrame:
    degree = nx.degree_centrality(graph)
    indegree = dict(graph.in_degree())
    outdegree = dict(graph.out_degree())
    betweenness = nx.betweenness_centrality(graph, normalized=True)
    pagerank = nx.pagerank(graph, weight="weight")

    rows = []
    for node, attrs in graph.nodes(data=True):
        rows.append(
            {
                "concept": node,
                "concept_id": attrs.get("concept_id"),
                "domain": attrs.get("domain"),
                "depth": attrs.get("depth"),
                "status": attrs.get("status"),
                "degree_centrality": degree.get(node, 0.0),
                "indegree": indegree.get(node, 0),
                "outdegree": outdegree.get(node, 0),
                "betweenness": betweenness.get(node, 0.0),
                "pagerank": pagerank.get(node, 0.0),
            }
        )

    return pd.DataFrame(rows).sort_values(
        ["degree_centrality", "betweenness", "pagerank"], ascending=False
    )


def conceptual_pathways(graph: nx.DiGraph) -> pd.DataFrame:
    targets = [
        ("Knowledge Architecture", "Decision Support"),
        ("Conceptual Frameworks", "Decision Support"),
        ("Taxonomy Design", "Knowledge Graphs"),
        ("Information Architecture", "Metadata Governance"),
    ]

    rows = []
    for source, target in targets:
        try:
            path = nx.shortest_path(graph, source=source, target=target)
            rows.append(
                {
                    "source": source,
                    "target": target,
                    "path_length": len(path) - 1,
                    "pathway": " -> ".join(path),
                }
            )
        except (nx.NetworkXNoPath, nx.NodeNotFound):
            rows.append(
                {
                    "source": source,
                    "target": target,
                    "path_length": None,
                    "pathway": "NO PATH",
                }
            )
    return pd.DataFrame(rows)


def summarize(concepts: pd.DataFrame, relationships: pd.DataFrame, graph: nx.DiGraph) -> dict:
    isolated = sorted(list(nx.isolates(graph)))
    weak_components = [sorted(list(c)) for c in nx.weakly_connected_components(graph)]

    return {
        "concept_count": int(len(concepts)),
        "relationship_count": int(len(relationships)),
        "domain_count": int(concepts["domain"].nunique()),
        "max_depth": int(concepts["depth"].max()),
        "mean_depth": float(concepts["depth"].mean()),
        "isolated_concepts": isolated,
        "weakly_connected_component_count": len(weak_components),
        "weakly_connected_components": weak_components,
    }


def main() -> None:
    config = ArchitectureConfig()
    concepts, relationships = load_inputs(config)
    graph = build_graph(concepts, relationships)

    metrics = graph_metrics(graph)
    pathways = conceptual_pathways(graph)
    summary = summarize(concepts, relationships, graph)

    metrics.to_csv(config.metrics_file, index=False)
    pathways.to_csv(config.pathways_file, index=False)
    config.summary_file.write_text(json.dumps(summary, indent=2), encoding="utf-8")

    print("Knowledge architecture graph analysis complete.")
    print(f"Wrote: {config.metrics_file}")
    print(f"Wrote: {config.pathways_file}")
    print(f"Wrote: {config.summary_file}")


if __name__ == "__main__":
    main()
