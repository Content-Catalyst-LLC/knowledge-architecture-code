-- Objects missing descriptive metadata.
SELECT object_id, title, object_type
FROM digital_objects
WHERE object_id NOT IN (SELECT DISTINCT object_id FROM object_metadata);

-- Preservation events by outcome.
SELECT outcome, COUNT(*) AS event_count
FROM preservation_events
GROUP BY outcome
ORDER BY event_count DESC;

-- Authority records needing review.
SELECT authority_id, preferred_label, authority_type, status
FROM authority_records
WHERE status = 'review_needed';
