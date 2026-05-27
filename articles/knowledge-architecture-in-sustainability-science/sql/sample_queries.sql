-- Objects needing review.
SELECT object_id, title, object_type, status
FROM sustainability_objects
WHERE status = 'review_needed';

-- Relationships missing provenance.
SELECT relationship_id, source_object_id, relationship_type_id, target_object_id
FROM sustainability_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Governance records for sensitive objects.
SELECT governance_id, object_id, governance_type, access_condition, sensitivity_level, review_status
FROM governance_records
WHERE sensitivity_level IN ('medium', 'high');

-- Indicators by scale.
SELECT scale, COUNT(*) AS indicator_count
FROM indicators
GROUP BY scale
ORDER BY indicator_count DESC;
