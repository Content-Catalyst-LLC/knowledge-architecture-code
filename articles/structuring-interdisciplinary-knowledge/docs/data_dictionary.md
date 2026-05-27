# Data Dictionary

## disciplines.csv

| Field | Meaning |
|---|---|
| discipline_id | Stable discipline identifier |
| name | Human-readable discipline or field name |
| scope_note | Description of the field's scope in this scaffold |
| parent_discipline_id | Optional broader field |
| status | active, provisional, deprecated |

## concepts.csv

| Field | Meaning |
|---|---|
| concept_id | Stable concept identifier |
| preferred_label | Human-readable concept label |
| discipline_id | Primary discipline context |
| definition | Short working definition |
| has_scope_note | Whether the concept has a scope note |
| has_method_context | Whether method/evidence context is documented |
| status | active, review_needed, contested |

## concept_crosswalks.csv

| Field | Meaning |
|---|---|
| source_concept_id | Source concept |
| relationship_type | exactMatch, closeMatch, broadMatch, narrowMatch, relatedMatch, contestedMatch, notEquivalent |
| target_concept_id | Target concept |
| provenance_note | Why the crosswalk exists |
| review_status | current, provisional, needs_review |

## methods.csv

| Field | Meaning |
|---|---|
| method_id | Stable method identifier |
| method_name | Method label |
| discipline_id | Primary discipline or field using the method |
| method_type | experimental, observational, modeling, interpretive, legal, archival, participatory |
| assumptions | Main assumptions |
| limitations | Main limitations |

## evidence_types.csv

| Field | Meaning |
|---|---|
| evidence_type_id | Stable evidence type identifier |
| label | Evidence label |
| typical_disciplines | Fields where the evidence type is common |
| review_note | Interpretation or caution note |

## governance_checks.csv

| Field | Meaning |
|---|---|
| check_id | Stable governance check identifier |
| layer | concepts, crosswalks, methods, evidence, AI, equity |
| check_name | Human-readable review question |
| severity | low, medium, high |
