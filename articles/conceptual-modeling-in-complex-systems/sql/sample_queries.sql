-- Components needing review.
SELECT component_id, label, component_type, status
FROM components
WHERE status = 'review_needed';

-- Relationships missing provenance.
SELECT relationship_id, source_component_id, relationship_type_id, target_component_id
FROM model_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Feedback loops by type.
SELECT loop_type, COUNT(*) AS loop_count
FROM feedback_loops
GROUP BY loop_type
ORDER BY loop_count DESC;

-- High-sensitivity assumptions.
SELECT assumption_id, assumption_text, assumption_type, sensitivity_level, review_status
FROM model_assumptions
WHERE sensitivity_level = 'high';
