-- Knowledge graph schema for semantic relationships, evidence, provenance, and governance.

CREATE TABLE IF NOT EXISTS kg_nodes (
  node_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  node_type TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'active',
  created_at DATE,
  updated_at DATE
);

CREATE TABLE IF NOT EXISTS relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  inverse_label TEXT,
  definition TEXT,
  domain_node_type TEXT,
  range_node_type TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS kg_edges (
  edge_id TEXT PRIMARY KEY,
  source_node_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_node_id TEXT NOT NULL,
  confidence_level TEXT DEFAULT 'provisional',
  provenance_id TEXT,
  status TEXT DEFAULT 'active',
  created_at DATE,
  updated_at DATE,
  FOREIGN KEY (source_node_id) REFERENCES kg_nodes(node_id),
  FOREIGN KEY (relationship_type_id) REFERENCES relationship_types(relationship_type_id),
  FOREIGN KEY (target_node_id) REFERENCES kg_nodes(node_id)
);

CREATE TABLE IF NOT EXISTS evidence_sources (
  provenance_id TEXT PRIMARY KEY,
  source_label TEXT NOT NULL,
  source_type TEXT,
  url TEXT,
  note TEXT
);

CREATE TABLE IF NOT EXISTS graph_revisions (
  revision_id INTEGER PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  change_type TEXT NOT NULL,
  change_note TEXT,
  changed_at DATE
);
