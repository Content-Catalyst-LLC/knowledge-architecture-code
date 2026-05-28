-- Decision questions needing review.
SELECT question_id, title, status, last_reviewed
FROM decision_questions
WHERE status = 'review_needed';

-- Relationships missing provenance.
SELECT relationship_id, source_object_id, relationship_type_id, target_object_id
FROM decision_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Weighted option scores.
SELECT
  ocs.option_id,
  SUM(ocs.score * dc.weight) / SUM(dc.weight) AS weighted_score
FROM option_criteria_scores ocs
JOIN decision_criteria dc ON dc.criterion_id = ocs.criterion_id
GROUP BY ocs.option_id
ORDER BY weighted_score DESC;

-- Feedback records requiring action.
SELECT feedback_id, decision_id, feedback_type, source_note, feedback_summary
FROM feedback_records
WHERE action_required = 1;
