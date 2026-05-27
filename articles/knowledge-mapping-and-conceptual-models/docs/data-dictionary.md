# Data Dictionary

## `concepts.csv`

- `concept_id`: Stable concept identifier.
- `label`: Human-readable concept label.
- `concept_type`: Role of the concept in the model.
- `domain`: Knowledge domain or architectural layer.
- `definition`: Concise working definition.
- `status`: Governance status.

## `relationships.csv`

- `source`: Source concept identifier.
- `target`: Target concept identifier.
- `relationship`: Typed relationship between concepts.
- `evidence_status`: Whether the relationship is documented, provisional, contested, or under review.
- `provenance_note`: Source or rationale for the relationship.

## `evidence_sources.csv`

- `evidence_id`: Stable source identifier.
- `citation`: Human-readable citation.
- `source_type`: Source category.
- `url`: Source URL where applicable.
- `notes`: Relevance note.

## `pathways.csv`

- `pathway_id`: Pathway identifier.
- `step_order`: Sequence position.
- `concept_id`: Concept included in the pathway.
- `pathway_type`: Learning, research, evidence, repository, or AI workflow pathway.
- `description`: Purpose of the pathway step.
