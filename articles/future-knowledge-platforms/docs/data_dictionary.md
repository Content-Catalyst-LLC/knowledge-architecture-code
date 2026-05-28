# Data Dictionary

## future_platform_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable platform object identifier |
| title | Human-readable title |
| object_type | article_map, article, dataset, repository, schema, taxonomy, graph, ai_retrieval, ai_output, governance, accessibility, resilience |
| has_metadata | Whether required descriptive and governance metadata exists |
| has_provenance | Whether origin, source, method, or revision provenance exists |
| has_reuse_context | Whether license, access, documentation, or reuse information exists |
| has_review_context | Whether editorial, AI, governance, accessibility, or technical review exists |
| status | active, provisional, review_needed, deprecated |

## future_platform_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source platform object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target platform object |
| provenance_note | Evidence, policy, graph, repository, retrieval, or review note supporting the relationship |
| uncertainty_note | Limitation or uncertainty note |
| review_status | current, provisional, needs_review |

## repositories.csv

| Field | Meaning |
|---|---|
| repository_id | Stable repository identifier |
| linked_object_id | Platform object supported by repository |
| repository_type | code, data, documentation, model, workflow |
| repository_url | Repository location |
| license_note | Reuse license or condition |
| readme_status | complete, partial, missing |
| reproducibility_status | complete, partial, missing |
| review_status | current, provisional, needs_review |

## ai_records.csv

| Field | Meaning |
|---|---|
| record_id | Stable AI record identifier |
| record_type | retrieval, output, summary, metadata_suggestion, relationship_suggestion |
| linked_object_id | Object retrieved, summarized, or suggested |
| grounding_note | Source, retrieval, or citation context |
| human_review_status | reviewed, provisional, needs_review, rejected |
| created_at | Record date |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable governance check identifier |
| layer | metadata, taxonomy, AI, repository, accessibility, reuse, governance, resilience, equity |
| check_name | Human-readable review question |
| severity | low, medium, high |
