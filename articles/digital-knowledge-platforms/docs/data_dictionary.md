# Data Dictionary

## platform_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable identifier for a platform object |
| title | Human-readable title |
| object_type | library, article_map, article, repository, source, dataset, method, output |
| slug | Public or repository-facing slug |
| has_metadata | Whether the object has sufficient metadata context |
| status | active, draft, planned, deprecated, archival |

## platform_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source platform object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target platform object |
| provenance_note | Evidence, rationale, or platform note supporting the relationship |
| status | active, provisional, deprecated |

## metadata_requirements.csv

| Field | Meaning |
|---|---|
| object_type | Platform object type |
| required_field | Metadata field required for that object type |
| purpose | Why the field is required |

## repository_alignment.csv

| Field | Meaning |
|---|---|
| article_id | Article object expected to have repository support |
| repository_id | Repository object linked to the article |
| expected_slug | Expected article slug/folder name |
| folder_exists_in_scaffold | Synthetic indicator for alignment test |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable check identifier |
| layer | Platform layer being reviewed |
| check_name | Human-readable check |
| severity | low, medium, high |
