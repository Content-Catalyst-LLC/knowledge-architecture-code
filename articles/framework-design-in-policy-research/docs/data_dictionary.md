# Data Dictionary

## policy_framework_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable object identifier |
| title | Human-readable title |
| object_type | policy_problem, evidence, policy_option, institution, stakeholder, indicator, evaluation, governance_record |
| has_metadata | Whether the object has sufficient metadata |
| has_equity_context | Whether equity, justice, affected-group, or distributional context exists |
| has_causal_context | Whether the object is tied to a causal pathway or theory of change |
| status | active, proposed, review_needed, deprecated |

## policy_framework_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source policy framework object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target policy framework object |
| provenance_note | Evidence, review, or rationale supporting the relationship |
| uncertainty_note | Limitation or uncertainty note |
| review_status | current, provisional, needs_review |

## decision_criteria.csv

| Field | Meaning |
|---|---|
| criterion_id | Stable decision criterion identifier |
| label | Criterion label |
| criterion_type | effectiveness, equity, fiscal, feasibility, legal, legitimacy, risk |
| weight | Illustrative weight |
| value_note | Value judgment or interpretation note |

## option_scores.csv

| Field | Meaning |
|---|---|
| option_id | Policy option identifier |
| criterion_id | Decision criterion identifier |
| score | Illustrative score |
| score_note | Explanation for score |
| evidence_id | Evidence source supporting the score |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable governance check identifier |
| layer | problem, evidence, causality, equity, implementation, evaluation, AI |
| check_name | Human-readable review question |
| severity | low, medium, high |
