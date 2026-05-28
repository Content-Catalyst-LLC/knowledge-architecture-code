-- Knowledge objects needing review.
SELECT object_id, title, object_type, status, review_status
FROM knowledge_objects
WHERE status IN ('provisional', 'review_needed', 'deprecated')
   OR review_status IN ('provisional', 'needs_review');

-- Relationships missing provenance.
SELECT relationship_id, source_object_id, relationship_type_id, target_object_id
FROM knowledge_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Repositories with incomplete reproducibility status.
SELECT repository_id, object_id, repository_type, repository_url, reproducibility_status, review_status
FROM repositories
WHERE reproducibility_status <> 'complete'
   OR review_status IN ('provisional', 'needs_review');

-- AI outputs requiring review.
SELECT output_id, output_type, grounding_note, review_status, created_at
FROM ai_outputs
WHERE review_status IN ('provisional', 'needs_review');

-- Accessibility records needing review.
SELECT accessibility_id, object_id, has_alt_text, has_captions, has_transcript, semantic_structure_status
FROM accessibility_records
WHERE review_status IN ('provisional', 'needs_review')
   OR has_alt_text = 0
   OR has_captions = 0
   OR has_transcript = 0;

-- Platform resilience issues.
SELECT resilience_id, object_id, resilience_type, resilience_status, risk_note, stewardship_action
FROM resilience_records
WHERE resilience_status IN ('partial', 'needs_review', 'provisional');
