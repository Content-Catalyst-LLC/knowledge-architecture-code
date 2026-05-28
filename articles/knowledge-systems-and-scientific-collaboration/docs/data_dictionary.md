# Data Dictionary

## scientific_collaboration_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable scientific collaboration object identifier |
| title | Human-readable title |
| object_type | question, method, data, metadata, software, output, publication, review, governance, ethics |
| has_metadata | Whether sufficient descriptive metadata exists |
| has_provenance | Whether origin, method, version, or production-history context exists |
| has_review_context | Whether peer review, ethics review, technical review, or governance context exists |
| status | active, provisional, review_needed, deprecated |

## scientific_collaboration_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source scientific object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target scientific object |
| provenance_note | Study-design, protocol, workflow, review, repository, or governance note |
| uncertainty_note | Limitation, assumption, or uncertainty note |
| review_status | current, provisional, needs_review |

## contributors.csv

| Field | Meaning |
|---|---|
| contributor_id | Stable contributor identifier |
| display_name | Public or synthetic contributor label |
| role | Primary contributor role |
| institution | Institution or organization type |
| contribution_note | Description of contribution |

## datasets.csv

| Field | Meaning |
|---|---|
| dataset_id | Stable dataset identifier |
| title | Dataset title |
| data_type | observational, experimental, simulation, administrative, survey, qualitative |
| collection_method | Method note |
| license_note | Reuse and license conditions |
| sensitivity_note | Privacy, community, ethical, or security limitation |
| metadata_status | complete, partial, missing |
| provenance_note | Origin and transformation record |
| review_status | current, provisional, needs_review |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable governance check identifier |
| layer | project, contributors, data, methods, software, publication, ethics, FAIR, AI, governance |
| check_name | Human-readable review question |
| severity | low, medium, high |
