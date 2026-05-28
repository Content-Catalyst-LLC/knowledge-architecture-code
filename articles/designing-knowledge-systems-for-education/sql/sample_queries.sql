-- Resources needing accessibility review.
SELECT lr.resource_id, lr.title, am.review_status, am.has_alt_text, am.has_captions, am.has_transcript
FROM learning_resources lr
LEFT JOIN accessibility_metadata am ON am.resource_id = lr.resource_id
WHERE am.review_status = 'needs_review'
   OR am.has_alt_text = 0
   OR am.has_captions = 0
   OR am.has_transcript = 0;

-- Objectives without assessments.
SELECT lo.objective_id, lo.title
FROM learning_objectives lo
LEFT JOIN assessments a ON a.objective_id = lo.objective_id
WHERE a.assessment_id IS NULL;

-- Feedback records requiring revision.
SELECT feedback_id, assessment_id, feedback_type, feedback_summary
FROM feedback_records
WHERE revision_required = 1;

-- Relationships missing provenance.
SELECT relationship_id, source_object_id, relationship_type_id, target_object_id
FROM educational_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Resources by difficulty level.
SELECT difficulty_level, COUNT(*) AS resource_count
FROM learning_resources
GROUP BY difficulty_level
ORDER BY resource_count DESC;
