-- Sample intellectual infrastructure audit queries.

-- Objects missing metadata.
SELECT po.object_id, po.title, po.object_type
FROM platform_objects po
WHERE po.object_id NOT IN (
  SELECT DISTINCT object_id FROM object_metadata
);

-- Relationships missing provenance.
SELECT relationship_id, source_object_id, relationship_type_id, target_object_id
FROM platform_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Repository-supported objects.
SELECT po.title, r.repository_url, orl.repository_role
FROM object_repository_links orl
JOIN platform_objects po ON po.object_id = orl.object_id
JOIN repositories r ON r.repository_id = orl.repository_id;

-- Governance records needing review.
SELECT governance_id, object_id, governance_type, review_status
FROM governance_records
WHERE review_status IN ('needs_review', 'expired');
