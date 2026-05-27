-- Framework audit queries.

-- Concepts by role.
SELECT role, COUNT(*) AS concept_count
FROM concepts
GROUP BY role
ORDER BY concept_count DESC, role;

-- Evidence status summary.
SELECT evidence_status, COUNT(*) AS concept_count
FROM concepts
GROUP BY evidence_status
ORDER BY concept_count DESC;

-- Relationship type summary.
SELECT relationship_type, COUNT(*) AS relationship_count
FROM relationships
GROUP BY relationship_type
ORDER BY relationship_count DESC;

-- Concepts without linked evidence.
SELECT c.concept_id, c.label, c.role
FROM concepts c
LEFT JOIN concept_evidence ce ON c.concept_id = ce.concept_id
WHERE ce.evidence_id IS NULL
ORDER BY c.label;
