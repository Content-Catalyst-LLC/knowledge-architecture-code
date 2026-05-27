-- Information Architecture vs. Knowledge Architecture
-- Minimal schema for comparing navigational IA structures with semantic KA structures.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS information_objects (
  object_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  slug TEXT,
  object_type TEXT NOT NULL,
  status TEXT DEFAULT 'active',
  has_metadata_context INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS navigation_links (
  link_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  navigation_type TEXT,
  label TEXT,
  sort_order INTEGER,
  FOREIGN KEY (source_object_id) REFERENCES information_objects(object_id),
  FOREIGN KEY (target_object_id) REFERENCES information_objects(object_id)
);

CREATE TABLE IF NOT EXISTS knowledge_concepts (
  concept_id TEXT PRIMARY KEY,
  preferred_label TEXT NOT NULL,
  definition TEXT,
  scope_note TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  domain_type TEXT,
  range_type TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS semantic_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  evidence_note TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (source_object_id) REFERENCES information_objects(object_id),
  FOREIGN KEY (relationship_type_id) REFERENCES relationship_types(relationship_type_id),
  FOREIGN KEY (target_object_id) REFERENCES information_objects(object_id)
);

CREATE TABLE IF NOT EXISTS object_concepts (
  object_id TEXT NOT NULL,
  concept_id TEXT NOT NULL,
  concept_role TEXT,
  PRIMARY KEY (object_id, concept_id),
  FOREIGN KEY (object_id) REFERENCES information_objects(object_id),
  FOREIGN KEY (concept_id) REFERENCES knowledge_concepts(concept_id)
);

CREATE TABLE IF NOT EXISTS architecture_revisions (
  revision_id INTEGER PRIMARY KEY,
  architecture_layer TEXT NOT NULL,
  object_id TEXT,
  change_type TEXT NOT NULL,
  change_note TEXT,
  changed_at DATE
);
