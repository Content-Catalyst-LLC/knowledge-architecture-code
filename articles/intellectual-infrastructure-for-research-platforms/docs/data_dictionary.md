# Data Dictionary

## infrastructure_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable object identifier |
| title | Human-readable title |
| object_type | article, article_map, repository, dataset, method, output, source, governance_record |
| has_metadata | Whether the object carries sufficient metadata |
| has_governance | Whether the object has review/governance context |
| status | active, draft, planned, deprecated, archival |

## infrastructure_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source infrastructure object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target infrastructure object |
| provenance_note | Evidence, rationale, or documentation supporting the relationship |
| status | active, provisional, deprecated |

## repository_alignment.csv

| Field | Meaning |
|---|---|
| article_id | Article object expected to have repository support |
| repository_id | Repository object linked to the article |
| expected_slug | Expected folder slug |
| folder_exists_in_scaffold | Synthetic alignment indicator |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable check identifier |
| layer | Infrastructure layer reviewed |
| check_name | Human-readable review question |
| severity | low, medium, high |
