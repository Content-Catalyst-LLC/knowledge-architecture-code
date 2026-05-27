-- Sustainability Knowledge Architecture Schema
-- Minimal schema for sustainability science knowledge architecture.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS sustainability_objects (
  object_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  object_type TEXT NOT NULL,
  slug TEXT,
  status TEXT DEFAULT 'active',
  created_at DATE,
  updated_at DATE,
  last_reviewed DATE
);

CREATE TABLE IF NOT EXISTS systems (
  system_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  system_type TEXT,
  scope_note TEXT,
  scale TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS concepts (
  concept_id TEXT PRIMARY KEY,
  preferred_label TEXT NOT NULL,
  definition TEXT,
  scope_note TEXT,
  primary_system_id TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (primary_system_id) REFERENCES systems(system_id)
);

CREATE TABLE IF NOT EXISTS evidence_objects (
  evidence_id TEXT PRIMARY KEY,
  object_id TEXT,
  evidence_type TEXT NOT NULL,
  method_note TEXT,
  source_note TEXT,
  uncertainty_note TEXT,
  scale TEXT,
  FOREIGN KEY (object_id) REFERENCES sustainability_objects(object_id)
);

CREATE TABLE IF NOT EXISTS indicators (
  indicator_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  definition TEXT,
  unit TEXT,
  source TEXT,
  scale TEXT,
  update_frequency TEXT,
  limitation_note TEXT
);

CREATE TABLE IF NOT EXISTS models (
  model_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  model_type TEXT,
  assumptions TEXT,
  parameters_note TEXT,
  validation_note TEXT,
  limitation_note TEXT
);

CREATE TABLE IF NOT EXISTS places (
  place_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  place_type TEXT,
  spatial_scale TEXT,
  governance_context TEXT,
  vulnerability_note TEXT
);

CREATE TABLE IF NOT EXISTS communities (
  community_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  description TEXT,
  access_condition TEXT,
  governance_note TEXT,
  sensitivity_level TEXT
);

CREATE TABLE IF NOT EXISTS relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS sustainability_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  provenance_note TEXT,
  uncertainty_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (source_object_id) REFERENCES sustainability_objects(object_id),
  FOREIGN KEY (relationship_type_id) REFERENCES relationship_types(relationship_type_id),
  FOREIGN KEY (target_object_id) REFERENCES sustainability_objects(object_id)
);

CREATE TABLE IF NOT EXISTS governance_records (
  governance_id TEXT PRIMARY KEY,
  object_id TEXT,
  governance_type TEXT NOT NULL,
  access_condition TEXT,
  sensitivity_level TEXT,
  justice_note TEXT,
  review_status TEXT,
  review_date DATE,
  FOREIGN KEY (object_id) REFERENCES sustainability_objects(object_id)
);

CREATE TABLE IF NOT EXISTS sustainability_revisions (
  revision_id INTEGER PRIMARY KEY,
  object_id TEXT,
  revision_type TEXT NOT NULL,
  revision_note TEXT,
  changed_at DATE,
  FOREIGN KEY (object_id) REFERENCES sustainability_objects(object_id)
);
