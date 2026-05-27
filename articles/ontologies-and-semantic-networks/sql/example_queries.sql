-- Example semantic-network governance queries.

-- Count active classes.
SELECT COUNT(*) AS active_class_count
FROM ontology_classes
WHERE status = 'active';

-- List relationship predicates.
SELECT property_id, label, property_type
FROM properties
ORDER BY property_id;

-- Find active semantic relationships.
SELECT
  sr.relationship_id,
  s.label AS subject_label,
  p.label AS predicate_label,
  o.label AS object_label,
  sr.evidence_note
FROM semantic_relationships sr
JOIN entities s ON sr.subject_entity_id = s.entity_id
JOIN properties p ON sr.property_id = p.property_id
JOIN entities o ON sr.object_entity_id = o.entity_id
WHERE sr.status = 'active';
