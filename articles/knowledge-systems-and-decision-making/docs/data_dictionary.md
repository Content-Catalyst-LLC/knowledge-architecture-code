# Data Dictionary

## decision_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable decision-system object identifier |
| title | Human-readable title |
| object_type | decision_question, evidence, option, criterion, actor, decision, outcome, feedback, governance_record |
| has_metadata | Whether sufficient metadata exists |
| has_equity_context | Whether affected-group, distributional, procedural, or rights context exists |
| has_review_context | Whether review status, rationale, or governance context exists |
| status | active, proposed, review_needed, deprecated |

## decision_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source decision object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target decision object |
| provenance_note | Evidence, rationale, or governance note supporting the relationship |
| uncertainty_note | Limitation, assumption, or uncertainty note |
| review_status | current, provisional, needs_review |

## decision_criteria.csv

| Field | Meaning |
|---|---|
| criterion_id | Stable decision criterion identifier |
| label | Criterion label |
| criterion_type | effectiveness, equity, feasibility, cost, legitimacy, risk, learning |
| weight | Illustrative weight |
| value_note | Value judgment or interpretation note |

## option_scores.csv

| Field | Meaning |
|---|---|
| option_id | Decision option identifier |
| criterion_id | Criterion identifier |
| score | Illustrative score |
| score_note | Explanation for score |
| evidence_id | Evidence source supporting the score |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable governance check identifier |
| layer | question, evidence, options, equity, traceability, feedback, AI |
| check_name | Human-readable review question |
| severity | low, medium, high |
