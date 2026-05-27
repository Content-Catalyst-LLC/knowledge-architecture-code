# Data Dictionary

## research_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable object identifier |
| title | Human-readable title |
| object_type | publication, dataset, software, governance_record, research_record, repository, community_record, source |
| has_metadata | Whether sufficient interpretive metadata exists |
| access_level | open, restricted, internal, community_governed |
| status | active, draft, deprecated, archival |

## object_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source research object |
| relationship_type | Typed institutional relationship |
| target_object_id | Target research object |
| provenance_note | Evidence, rationale, or source note |
| status | active, provisional, deprecated |

## metadata_requirements.csv

| Field | Meaning |
|---|---|
| object_type | Institutional knowledge object type |
| required_field | Required metadata field |
| purpose | Why the field matters |

## governance_records.csv

| Field | Meaning |
|---|---|
| governance_id | Stable governance identifier |
| object_id | Object governed by the record |
| governance_type | ethics, data_management, access_control, community_agreement, AI_retrieval |
| sensitivity_level | low, medium, high |
| access_condition | open, restricted, mediated, community-governed |
| review_status | current, needs_review, expired |

## stewardship_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable check identifier |
| layer | metadata, repository, ethics, AI, equity, preservation |
| check_name | Review question |
| severity | low, medium, high |
