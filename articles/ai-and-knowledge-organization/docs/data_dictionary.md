# Data Dictionary

## ai_ko_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable AI knowledge-organization object identifier |
| title | Human-readable title |
| object_type | article, schema, taxonomy, ontology, graph, vector_index, retrieval, ai_output, review, governance |
| has_metadata | Whether required descriptive and governance metadata exists |
| has_provenance | Whether origin, source, method, or pipeline provenance exists |
| has_review_context | Whether human review, audit, or approval context exists |
| status | active, provisional, review_needed, deprecated |

## ai_ko_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source knowledge object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target knowledge object |
| provenance_note | Rationale, pipeline log, retrieval trace, review record, or schema source |
| uncertainty_note | Limitation or uncertainty note |
| review_status | current, provisional, needs_review |

## retrieval_records.csv

| Field | Meaning |
|---|---|
| retrieval_id | Stable retrieval record identifier |
| index_id | Linked embedding or search index |
| query_text | Query text |
| retrieved_object_id | Retrieved knowledge object |
| rank_position | Retrieval rank |
| relevance_note | Explanation of relevance |
| reviewed | Whether the retrieval result was reviewed |

## ai_outputs.csv

| Field | Meaning |
|---|---|
| output_id | Stable AI output identifier |
| output_type | summary, classification, recommendation, answer, extraction |
| prompt_note | Prompt or task context |
| model_note | AI model or workflow note |
| grounding_note | Source grounding context |
| review_status | provisional, reviewed, rejected, needs_review |
| created_at | Output date |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable governance check identifier |
| layer | metadata, taxonomy, ontology, retrieval, RAG, source_hierarchy, AI_output, equity, privacy, governance |
| check_name | Human-readable review question |
| severity | low, medium, high |
