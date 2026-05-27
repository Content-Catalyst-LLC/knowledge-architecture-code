# Data Dictionary

## nodes.csv

- `node_id`: stable identifier for the graph node
- `label`: human-readable node label
- `node_type`: class or type of node, such as Article, Concept, Standard, Application, RepositoryFolder, or EvidenceSource
- `description`: short description of the node
- `status`: active, provisional, deprecated, or archival

## relationship_types.csv

- `relationship_type_id`: stable identifier for a relationship predicate
- `label`: human-readable relationship name
- `domain_node_type`: expected source node type
- `range_node_type`: expected target node type
- `definition`: meaning of the relationship type

## edges.csv

- `edge_id`: stable identifier for the edge assertion
- `source_node_id`: source node
- `relationship_type_id`: relationship predicate
- `target_node_id`: target node
- `confidence_level`: provisional, reviewed, or authoritative
- `provenance_id`: evidence or rationale supporting the edge

## evidence_sources.csv

- `provenance_id`: stable provenance identifier
- `source_label`: human-readable source label
- `source_type`: standard, article_body, repository_metadata, reference, editorial_rationale, or synthetic_example
- `url`: optional URL
- `note`: description of the provenance role
