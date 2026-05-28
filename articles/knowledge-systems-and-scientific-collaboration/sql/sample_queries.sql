-- Datasets needing metadata or provenance review.
SELECT dataset_id, title, metadata_status, provenance_note, review_status
FROM datasets
WHERE metadata_status <> 'complete'
   OR provenance_note IS NULL
   OR TRIM(provenance_note) = ''
   OR review_status IN ('provisional', 'needs_review');

-- Software artifacts that are not fully tested.
SELECT software_id, title, software_type, repository_url, test_status, review_status
FROM software_artifacts
WHERE test_status <> 'complete'
   OR review_status IN ('provisional', 'needs_review');

-- Contributor roles by project.
SELECT pc.project_id, cr.label AS contributor_role, COUNT(*) AS contributor_count
FROM project_contributions pc
JOIN contributor_roles cr ON cr.role_id = pc.role_id
GROUP BY pc.project_id, cr.label
ORDER BY pc.project_id, contributor_count DESC;

-- Relationships missing provenance.
SELECT relationship_id, source_object_id, relationship_type_id, target_object_id
FROM collaboration_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Publications with correction status.
SELECT publication_id, title, publication_status, version_note, correction_status
FROM publications
WHERE correction_status IS NOT NULL;
