-- Governance decisions lacking review pathways.
SELECT decision_id, title, decision_authority, review_pathway
FROM governance_decisions
WHERE review_pathway IS NULL OR TRIM(review_pathway) = '';

-- Participation records without institutional response.
SELECT participation_id, decision_id, actor_id, participation_method
FROM participation_records
WHERE response_note IS NULL OR TRIM(response_note) = ''
   OR influence_note IS NULL OR TRIM(influence_note) = '';

-- Governance relationships missing provenance.
SELECT relationship_id, source_object_id, relationship_type_id, target_object_id
FROM governance_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Audit records requiring follow-up.
SELECT audit_id, decision_id, severity, recommendation, follow_up_status
FROM audit_records
WHERE follow_up_status IN ('open', 'overdue', 'needs_review');

-- Decisions with budget records and outcome indicators.
SELECT
  gd.decision_id,
  gd.title,
  br.amount,
  br.currency,
  oi.label AS outcome_indicator
FROM governance_decisions gd
LEFT JOIN budget_records br ON br.decision_id = gd.decision_id
LEFT JOIN outcome_indicators oi ON oi.decision_id = gd.decision_id;
