# Data Dictionary

## information_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable object identifier |
| title | Human-readable title |
| object_type | Page, article_map, article, repository, source, concept |
| has_metadata_context | Whether the object has enough metadata context for interpretation |

## navigation_links.csv

| Field | Meaning |
|---|---|
| source_object_id | Origin page/object |
| target_object_id | Destination page/object |
| navigation_type | Gateway, article_map, repository_link, related_article |
| label | Human-facing navigation label |

## semantic_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source knowledge object |
| relationship_type | Typed semantic relationship |
| target_object_id | Target knowledge object |
| evidence_note | Rationale, source, or documentation note |

## relationship_types.csv

| Field | Meaning |
|---|---|
| relationship_type | Controlled relationship predicate |
| definition | Meaning of the relationship |
| layer | IA, KA, or shared architectural layer |
