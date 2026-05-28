-- Knowledge objects needing review.
SELECT object_id, title, object_type, review_status
FROM knowledge_objects
WHERE review_status IN ('provisional', 'needs_review', 'review_needed');

-- Relationships missing provenance.
SELECT relationship_id, source_object_id, relationship_type_id, target_object_id
FROM knowledge_relationships
WHERE provenance_note IS NULL OR TRIM(provenance_note) = '';

-- Retrieval records that have not been reviewed.
SELECT retrieval_id, index_id, query_text, retrieved_object_id, rank_position
FROM retrieval_records
WHERE reviewed = 0;

-- AI outputs that require human review.
SELECT output_id, output_type, model_note, grounding_note, review_status
FROM ai_outputs
WHERE review_status IN ('provisional', 'needs_review');

-- Required metadata fields.
SELECT field_id, label, definition
FROM metadata_fields
WHERE required = 1;

-- Source hierarchy rules by authority rank.
SELECT authority_rank, COUNT(*) AS rule_count
FROM source_hierarchy_rules
GROUP BY authority_rank
ORDER BY authority_rank ASC;
