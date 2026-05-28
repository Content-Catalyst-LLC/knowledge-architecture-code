-- Knowledge objects needing review.
SELECT object_id, title, object_type, scale, review_status
FROM knowledge_objects
WHERE review_status IN ('review_needed', 'needs_review', 'provisional');

-- Relationships missing provenance.
SELECT relationship_id, source_object_id, relationship_type_id, target_object_id
FROM knowledge_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Feedback loops by type.
SELECT loop_type, COUNT(*) AS loop_count
FROM feedback_loops
GROUP BY loop_type
ORDER BY loop_count DESC;

-- High-sensitivity assumptions.
SELECT assumption_id, assumption_text, assumption_type, sensitivity_level, review_status
FROM assumptions
WHERE sensitivity_level = 'high';

-- Objects by scale.
SELECT scale, COUNT(*) AS object_count
FROM knowledge_objects
GROUP BY scale
ORDER BY object_count DESC;
