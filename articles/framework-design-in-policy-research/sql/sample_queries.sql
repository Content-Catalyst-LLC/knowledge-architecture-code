-- Evidence sources needing review.
SELECT evidence_id, title, evidence_type, status
FROM evidence_sources
WHERE status = 'review_needed';

-- Relationships missing provenance.
SELECT relationship_id, source_object_id, relationship_type_id, target_object_id
FROM framework_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Weighted option scores.
SELECT
  os.option_id,
  SUM(os.score * dc.weight) / SUM(dc.weight) AS weighted_score
FROM option_scores os
JOIN decision_criteria dc ON dc.criterion_id = os.criterion_id
GROUP BY os.option_id
ORDER BY weighted_score DESC;

-- Stakeholders by participation status.
SELECT participation_status, COUNT(*) AS stakeholder_count
FROM stakeholders
GROUP BY participation_status
ORDER BY stakeholder_count DESC;
