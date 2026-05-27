-- hierarchical_knowledge_structure_schema.sql
-- Parent-child, closure-table, assignment, and revision schema.

CREATE TABLE IF NOT EXISTS hierarchy_nodes (
  node_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  node_type TEXT,
  domain TEXT,
  scope_note TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS hierarchy_edges (
  parent_id TEXT NOT NULL,
  child_id TEXT NOT NULL,
  relationship_type TEXT DEFAULT 'broader_narrower',
  sort_order INTEGER,
  PRIMARY KEY (parent_id, child_id),
  FOREIGN KEY (parent_id) REFERENCES hierarchy_nodes(node_id),
  FOREIGN KEY (child_id) REFERENCES hierarchy_nodes(node_id)
);

CREATE TABLE IF NOT EXISTS hierarchy_closure (
  ancestor_id TEXT NOT NULL,
  descendant_id TEXT NOT NULL,
  depth INTEGER NOT NULL,
  PRIMARY KEY (ancestor_id, descendant_id),
  FOREIGN KEY (ancestor_id) REFERENCES hierarchy_nodes(node_id),
  FOREIGN KEY (descendant_id) REFERENCES hierarchy_nodes(node_id)
);

CREATE TABLE IF NOT EXISTS knowledge_objects (
  object_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  slug TEXT,
  object_type TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS object_hierarchy_assignments (
  object_id TEXT NOT NULL,
  node_id TEXT NOT NULL,
  assignment_type TEXT DEFAULT 'primary',
  PRIMARY KEY (object_id, node_id),
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id),
  FOREIGN KEY (node_id) REFERENCES hierarchy_nodes(node_id)
);

CREATE TABLE IF NOT EXISTS hierarchy_revisions (
  revision_id INTEGER PRIMARY KEY,
  node_id TEXT,
  change_type TEXT NOT NULL,
  change_note TEXT,
  changed_at DATE,
  FOREIGN KEY (node_id) REFERENCES hierarchy_nodes(node_id)
);
