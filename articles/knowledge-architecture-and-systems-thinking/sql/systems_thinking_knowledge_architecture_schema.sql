-- Systems Thinking Knowledge Architecture Schema
-- Minimal schema for knowledge architecture and systems thinking.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS knowledge_systems (
  system_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  system_type TEXT,
  scope_note TEXT,
  boundary_note TEXT,
  scale TEXT,
  status TEXT DEFAULT 'active',
  last_reviewed DATE
);

CREATE TABLE IF NOT EXISTS knowledge_objects (
  object_id TEXT PRIMARY KEY,
  system_id TEXT,
  title TEXT NOT NULL,
  object_type TEXT NOT NULL,
  description TEXT,
  scale TEXT,
  metadata_status TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (system_id) REFERENCES knowledge_systems(system_id)
);

CREATE TABLE IF NOT EXISTS relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  feedback_relevance INTEGER DEFAULT 0,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS knowledge_relationships (
  relationship_id INTEGER PRIMARY KEY,
  system_id TEXT,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  provenance_note TEXT,
  uncertainty_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (system_id) REFERENCES knowledge_systems(system_id),
  FOREIGN KEY (source_object_id) REFERENCES knowledge_objects(object_id),
  FOREIGN KEY (relationship_type_id) REFERENCES relationship_types(relationship_type_id),
  FOREIGN KEY (target_object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS feedback_loops (
  loop_id TEXT PRIMARY KEY,
  system_id TEXT,
  loop_name TEXT NOT NULL,
  loop_type TEXT,
  description TEXT,
  evidence_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (system_id) REFERENCES knowledge_systems(system_id)
);

CREATE TABLE IF NOT EXISTS loop_relationships (
  loop_id TEXT NOT NULL,
  relationship_id INTEGER NOT NULL,
  sequence_order INTEGER,
  PRIMARY KEY (loop_id, relationship_id),
  FOREIGN KEY (loop_id) REFERENCES feedback_loops(loop_id),
  FOREIGN KEY (relationship_id) REFERENCES knowledge_relationships(relationship_id)
);

CREATE TABLE IF NOT EXISTS assumptions (
  assumption_id TEXT PRIMARY KEY,
  system_id TEXT,
  assumption_text TEXT NOT NULL,
  assumption_type TEXT,
  sensitivity_level TEXT,
  evidence_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (system_id) REFERENCES knowledge_systems(system_id)
);

CREATE TABLE IF NOT EXISTS evidence_links (
  evidence_id TEXT PRIMARY KEY,
  object_id TEXT,
  evidence_type TEXT,
  source_note TEXT,
  quality_note TEXT,
  uncertainty_note TEXT,
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS revision_records (
  revision_id TEXT PRIMARY KEY,
  object_id TEXT,
  revision_type TEXT,
  revision_note TEXT,
  changed_at DATE,
  reviewed_by TEXT,
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS governance_checks (
  check_id TEXT PRIMARY KEY,
  system_id TEXT,
  layer TEXT,
  check_name TEXT,
  severity TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (system_id) REFERENCES knowledge_systems(system_id)
);
