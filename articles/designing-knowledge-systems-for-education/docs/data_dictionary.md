# Data Dictionary

## educational_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable educational object identifier |
| title | Human-readable title |
| object_type | concept, objective, resource, practice, assessment, rubric, feedback, governance, repository |
| has_metadata | Whether sufficient metadata exists |
| has_accessibility_context | Whether accessibility metadata exists |
| has_review_context | Whether review status, rationale, or governance context exists |
| status | active, provisional, review_needed, deprecated |

## educational_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source educational object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target educational object |
| provenance_note | Curriculum, lesson, assessment, accessibility, or review note supporting the relationship |
| uncertainty_note | Limitation, assumption, or uncertainty note |
| review_status | current, provisional, needs_review |

## learning_resources.csv

| Field | Meaning |
|---|---|
| resource_id | Stable resource identifier |
| title | Resource title |
| resource_type | reading, diagram, video, simulation, dataset, practice, project |
| difficulty_level | introductory, intermediate, advanced |
| estimated_time_minutes | Estimated learner time |
| license_note | License or OER status |
| accessibility_note | Accessibility status |
| review_status | current, provisional, needs_review |

## accessibility_metadata.csv

| Field | Meaning |
|---|---|
| accessibility_id | Stable accessibility record identifier |
| resource_id | Linked resource |
| has_alt_text | Whether alt text exists where needed |
| has_captions | Whether captions exist where needed |
| has_transcript | Whether transcript exists where needed |
| keyboard_accessible | Whether keyboard navigation works |
| format_alternative_note | Alternative format note |
| review_status | current, provisional, needs_review |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable governance check identifier |
| layer | curriculum, objectives, resources, assessment, accessibility, feedback, AI, privacy, governance |
| check_name | Human-readable review question |
| severity | low, medium, high |
