-- Sample audit queries for a knowledge graph.

-- Relationship type counts
SELECT relationship_type_id, COUNT(*) AS edge_count
FROM kg_edges
GROUP BY relationship_type_id
ORDER BY edge_count DESC;

-- Nodes without graph relationships
SELECT n.node_id, n.label, n.node_type
FROM kg_nodes n
LEFT JOIN kg_edges e1 ON n.node_id = e1.source_node_id
LEFT JOIN kg_edges e2 ON n.node_id = e2.target_node_id
WHERE e1.edge_id IS NULL AND e2.edge_id IS NULL;

-- Edges without provenance
SELECT edge_id, source_node_id, relationship_type_id, target_node_id
FROM kg_edges
WHERE provenance_id IS NULL OR provenance_id = '';

-- Concept-to-application paths, simplified
SELECT e.source_node_id, e.relationship_type_id, e.target_node_id
FROM kg_edges e
JOIN kg_nodes source ON source.node_id = e.source_node_id
JOIN kg_nodes target ON target.node_id = e.target_node_id
WHERE source.node_type = 'Concept' AND target.node_type = 'Application';
