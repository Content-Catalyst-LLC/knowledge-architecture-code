# Data Dictionary

## knowledge_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable knowledge object identifier |
| title | Human-readable title |
| object_type | article_map, framework, evidence, model, decision, outcome, governance, AI, repository |
| has_metadata | Whether sufficient metadata exists |
| scale | source, concept, article, domain, institutional, platform, system |
| has_feedback_role | Whether the object participates in feedback, review, or revision |
| status | active, provisional, review_needed, deprecated |

## knowledge_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source knowledge object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target knowledge object |
| provenance_note | Evidence, rationale, review, or architecture note supporting the relationship |
| uncertainty_note | Limitation or uncertainty note |
| feedback_relevant | Whether the relationship participates in a feedback loop |
| review_status | current, provisional, needs_review |

## feedback_loops.csv

| Field | Meaning |
|---|---|
| loop_id | Stable feedback-loop identifier |
| loop_name | Human-readable loop name |
| loop_type | reinforcing, balancing, corrective, learning |
| description | Feedback-loop description |
| evidence_note | Evidence or architecture rationale |
| review_status | current, provisional, needs_review |

## assumptions.csv

| Field | Meaning |
|---|---|
| assumption_id | Stable assumption identifier |
| assumption_text | Assumption statement |
| assumption_type | boundary, category, relationship, evidence, AI, governance |
| sensitivity_level | low, medium, high |
| review_status | current, provisional, needs_review |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable governance check identifier |
| layer | boundary, objects, relationships, feedback, scale, assumptions, AI, governance |
| check_name | Human-readable review question |
| severity | low, medium, high |
