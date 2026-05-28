# Data Dictionary

## governance_objects.csv

| Field | Meaning |
|---|---|
| object_id | Stable governance object identifier |
| title | Human-readable title |
| object_type | institution, rule, decision, evidence, resource, participation, actor, implementation, outcome, audit, revision, governance_record |
| has_metadata | Whether sufficient metadata exists |
| has_accountability_context | Whether authority, rationale, review, or correction context exists |
| has_equity_context | Whether affected-group, distributional, procedural, or rights context exists |
| status | active, provisional, review_needed, deprecated |

## governance_relationships.csv

| Field | Meaning |
|---|---|
| source_object_id | Source governance object |
| relationship_type | Typed relationship predicate |
| target_object_id | Target governance object |
| provenance_note | Evidence, authority, rationale, audit, or review note supporting the relationship |
| uncertainty_note | Limitation, assumption, or uncertainty note |
| review_status | current, provisional, needs_review |

## institutions.csv

| Field | Meaning |
|---|---|
| institution_id | Stable institution identifier |
| name | Institution name |
| institution_type | agency, court, legislature, oversight_body, civic_body, international_org |
| jurisdiction | Jurisdiction or institutional domain |
| mandate_note | Authority or public purpose |
| accountability_note | Accountability mechanism or review path |
| status | active, provisional, review_needed |

## participation_records.csv

| Field | Meaning |
|---|---|
| participation_id | Stable participation record identifier |
| decision_id | Linked decision |
| actor_id | Linked actor or affected group |
| participation_method | consultation, public comment, hearing, participatory review, community review |
| summary | Summary of input |
| response_note | Institutional response |
| influence_note | Whether/how input changed the decision |
| review_status | current, provisional, needs_review |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable governance check identifier |
| layer | authority, evidence, participation, accountability, equity, AI, revision |
| check_name | Human-readable review question |
| severity | low, medium, high |
