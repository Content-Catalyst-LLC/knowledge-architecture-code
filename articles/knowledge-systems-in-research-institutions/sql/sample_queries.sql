-- Sample institutional knowledge-system audit queries.

-- Objects missing metadata.
SELECT ro.object_id, ro.title, ro.object_type
FROM research_objects ro
WHERE ro.object_id NOT IN (
  SELECT DISTINCT object_id FROM object_metadata
);

-- Restricted or community-governed objects without governance records.
SELECT ro.object_id, ro.title, ro.access_level
FROM research_objects ro
WHERE ro.access_level IN ('restricted', 'community_governed')
AND ro.object_id NOT IN (
  SELECT DISTINCT object_id FROM governance_records
);

-- Relationship type frequency.
SELECT relationship_type_id, COUNT(*) AS relationship_count
FROM object_relationships
GROUP BY relationship_type_id
ORDER BY relationship_count DESC;

-- Governance records needing review.
SELECT governance_id, object_id, governance_type, sensitivity_level, review_status
FROM governance_records
WHERE review_status = 'needs_review';
