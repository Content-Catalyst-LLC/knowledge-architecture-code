# Data Dictionary

## sustainability_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable object identifier |
| title | Human-readable title |
| object_type | article, dataset, indicator, policy, model, community_record, repository, governance_record |
| has_metadata | Whether sufficient metadata exists |
| scale | local, regional, national, global, platform |
| has_justice_context | Whether relevant justice context is documented |
| has_uncertainty_context | Whether uncertainty, limitation, or assumption context exists |
| status | active, review_needed, restricted, deprecated |

## sustainability_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source sustainability object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target sustainability object |
| provenance_note | Evidence, source, or review note supporting the relationship |
| uncertainty_note | Uncertainty or limitation note |
| review_status | current, provisional, needs_review |

## systems.csv

| Field | Meaning |
|---|---|
| system_id | Stable system identifier |
| name | Human-readable system name |
| system_type | ecological, social, technical, institutional, economic, mixed |
| scale | local, regional, national, global |
| scope_note | System scope and boundaries |

## concepts.csv

| Field | Meaning |
|---|---|
| concept_id | Stable concept identifier |
| preferred_label | Human-readable concept label |
| definition | Working definition |
| primary_system_id | System most closely associated with the concept |
| status | active, contested, review_needed |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable check identifier |
| layer | metadata, scale, justice, evidence, AI, governance |
| check_name | Human-readable review question |
| severity | low, medium, high |
