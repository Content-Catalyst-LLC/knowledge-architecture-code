-- Sample digital knowledge platform audit queries.

-- Objects without metadata.
SELECT object_id, title, object_type
FROM platform_objects
WHERE object_id NOT IN (
  SELECT DISTINCT object_id FROM object_metadata
);

-- Relationship types by frequency.
SELECT relationship_type_id, COUNT(*) AS relationship_count
FROM platform_relationships
GROUP BY relationship_type_id
ORDER BY relationship_count DESC;

-- Repository-supported articles.
SELECT po.title, r.repository_url, orl.repository_role
FROM object_repository_links orl
JOIN platform_objects po ON po.object_id = orl.object_id
JOIN repositories r ON r.repository_id = orl.repository_id;

-- Active governance checks by severity.
SELECT severity, COUNT(*) AS check_count
FROM governance_checks
WHERE status = 'active'
GROUP BY severity
ORDER BY check_count DESC;
