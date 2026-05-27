-- Example taxonomy quality queries.

-- Terms without scope notes.
SELECT term_id, preferred_label
FROM taxonomy_terms
WHERE scope_note IS NULL OR TRIM(scope_note) = '';

-- Terms with no assignments.
SELECT t.term_id, t.preferred_label
FROM taxonomy_terms t
LEFT JOIN term_assignments a ON t.term_id = a.term_id
WHERE a.term_id IS NULL;

-- Child counts by parent.
SELECT parent_id, COUNT(*) AS child_count
FROM taxonomy_terms
WHERE parent_id IS NOT NULL AND parent_id != ''
GROUP BY parent_id
ORDER BY child_count DESC;
