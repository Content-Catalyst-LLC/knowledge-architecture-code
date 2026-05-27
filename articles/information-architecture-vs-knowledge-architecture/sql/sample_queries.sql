-- Sample IA/KA audit queries.

-- Objects visible through navigation but missing semantic relationships.
SELECT io.object_id, io.title, io.object_type
FROM information_objects io
WHERE EXISTS (
  SELECT 1 FROM navigation_links nl
  WHERE nl.source_object_id = io.object_id OR nl.target_object_id = io.object_id
)
AND NOT EXISTS (
  SELECT 1 FROM semantic_relationships sr
  WHERE sr.source_object_id = io.object_id OR sr.target_object_id = io.object_id
);

-- Objects semantically connected but missing metadata context.
SELECT object_id, title, object_type
FROM information_objects
WHERE has_metadata_context = 0
AND EXISTS (
  SELECT 1 FROM semantic_relationships sr
  WHERE sr.source_object_id = information_objects.object_id
     OR sr.target_object_id = information_objects.object_id
);

-- Relationship type frequency.
SELECT relationship_type_id, COUNT(*) AS edge_count
FROM semantic_relationships
GROUP BY relationship_type_id
ORDER BY edge_count DESC;
