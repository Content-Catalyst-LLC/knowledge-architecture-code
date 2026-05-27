-- audit_queries.sql
-- Useful SQL checks for hierarchy review.

-- Root nodes.
SELECT n.node_id, n.label
FROM hierarchy_nodes n
LEFT JOIN hierarchy_edges e ON n.node_id = e.child_id
WHERE e.child_id IS NULL;

-- Leaf nodes.
SELECT n.node_id, n.label
FROM hierarchy_nodes n
LEFT JOIN hierarchy_edges e ON n.node_id = e.parent_id
WHERE e.parent_id IS NULL;

-- Parent nodes with many children.
SELECT parent_id, COUNT(*) AS child_count
FROM hierarchy_edges
GROUP BY parent_id
ORDER BY child_count DESC;

-- Objects without hierarchy assignments.
SELECT o.object_id, o.title
FROM knowledge_objects o
LEFT JOIN object_hierarchy_assignments a ON o.object_id = a.object_id
WHERE a.object_id IS NULL;
