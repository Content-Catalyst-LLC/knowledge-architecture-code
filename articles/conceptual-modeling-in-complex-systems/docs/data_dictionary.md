# Data Dictionary

## systems.csv

| Field | Meaning |
|---|---|
| system_id | Stable system identifier |
| title | Human-readable system title |
| system_type | ecological, social, technical, institutional, mixed |
| scope_note | What the system represents |
| boundary_note | What is included and excluded |
| spatial_scale | local, city, regional, national, global, platform |
| temporal_scale | short-term, medium-term, long-term, multi-decade |
| status | active, review_needed, deprecated |

## components.csv

| Field | Meaning |
|---|---|
| component_id | Stable component identifier |
| system_id | Parent system identifier |
| label | Human-readable component label |
| component_type | driver, stock, flow, outcome, actor_system, social_variable, feedback_process, emergent_property |
| definition | Component definition |
| scale | Analytical or spatial scale |
| has_metadata | Whether the component has sufficient metadata |
| has_uncertainty_context | Whether uncertainty context exists |
| status | active, review_needed, provisional |

## relationships.csv

| Field | Meaning |
|---|---|
| source_component_id | Source component |
| relationship_type | Relationship predicate |
| target_component_id | Target component |
| polarity | positive, negative, mixed, unknown |
| delay_note | Time-delay context |
| provenance_note | Evidence or rationale supporting the relationship |
| uncertainty_note | Limitation or uncertainty |
| feedback_relevant | Whether the relationship participates in feedback |
| review_status | current, provisional, needs_review |

## assumptions.csv

| Field | Meaning |
|---|---|
| assumption_id | Stable assumption identifier |
| system_id | Related system |
| assumption_text | Assumption statement |
| assumption_type | boundary, causal, behavioral, parameter, scenario, value |
| evidence_note | Evidence or rationale |
| sensitivity_level | low, medium, high |
| review_status | current, provisional, needs_review |

## feedback_loops.csv

| Field | Meaning |
|---|---|
| loop_id | Stable feedback-loop identifier |
| system_id | Parent system |
| loop_name | Loop label |
| loop_type | reinforcing, balancing, mixed |
| description | Loop description |
| evidence_note | Evidence or rationale |
| review_status | current, provisional, needs_review |
