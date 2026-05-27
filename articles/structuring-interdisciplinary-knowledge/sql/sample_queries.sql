-- Concepts missing scope notes.
SELECT concept_id, preferred_label, discipline_id
FROM concepts
WHERE scope_note IS NULL OR TRIM(scope_note) = '';

-- Crosswalks missing provenance.
SELECT crosswalk_id, source_concept_id, relationship_type_id, target_concept_id
FROM concept_crosswalks
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Crosswalk relationship counts.
SELECT relationship_type_id, COUNT(*) AS crosswalk_count
FROM concept_crosswalks
GROUP BY relationship_type_id
ORDER BY crosswalk_count DESC;

-- Governance reviews needing action.
SELECT object_type, object_id, review_type, review_status, review_note
FROM governance_reviews
WHERE review_status IN ('needs_review', 'provisional');
