-- Institutional Knowledge System Schema
-- Minimal schema for knowledge systems in research institutions.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS research_objects (
  object_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  object_type TEXT NOT NULL,
  slug TEXT,
  access_level TEXT,
  status TEXT DEFAULT 'active',
  created_at DATE,
  updated_at DATE,
  last_reviewed DATE
);

CREATE TABLE IF NOT EXISTS institutional_units (
  unit_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  unit_type TEXT,
  parent_unit_id TEXT,
  FOREIGN KEY (parent_unit_id) REFERENCES institutional_units(unit_id)
);

CREATE TABLE IF NOT EXISTS object_unit_links (
  object_id TEXT NOT NULL,
  unit_id TEXT NOT NULL,
  role TEXT,
  PRIMARY KEY (object_id, unit_id),
  FOREIGN KEY (object_id) REFERENCES research_objects(object_id),
  FOREIGN KEY (unit_id) REFERENCES institutional_units(unit_id)
);

CREATE TABLE IF NOT EXISTS metadata_fields (
  field_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  field_type TEXT,
  required INTEGER DEFAULT 0,
  definition TEXT
);

CREATE TABLE IF NOT EXISTS object_metadata (
  object_id TEXT NOT NULL,
  field_id TEXT NOT NULL,
  value TEXT,
  PRIMARY KEY (object_id, field_id),
  FOREIGN KEY (object_id) REFERENCES research_objects(object_id),
  FOREIGN KEY (field_id) REFERENCES metadata_fields(field_id)
);

CREATE TABLE IF NOT EXISTS relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  domain_object_type TEXT,
  range_object_type TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS object_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  provenance_note TEXT,
  confidence_level TEXT DEFAULT 'provisional',
  status TEXT DEFAULT 'active',
  FOREIGN KEY (source_object_id) REFERENCES research_objects(object_id),
  FOREIGN KEY (relationship_type_id) REFERENCES relationship_types(relationship_type_id),
  FOREIGN KEY (target_object_id) REFERENCES research_objects(object_id)
);

CREATE TABLE IF NOT EXISTS repositories (
  repository_id TEXT PRIMARY KEY,
  repository_name TEXT NOT NULL,
  repository_url TEXT,
  repository_type TEXT,
  access_model TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS object_repository_links (
  object_id TEXT NOT NULL,
  repository_id TEXT NOT NULL,
  repository_role TEXT,
  PRIMARY KEY (object_id, repository_id),
  FOREIGN KEY (object_id) REFERENCES research_objects(object_id),
  FOREIGN KEY (repository_id) REFERENCES repositories(repository_id)
);

CREATE TABLE IF NOT EXISTS governance_records (
  governance_id TEXT PRIMARY KEY,
  object_id TEXT,
  governance_type TEXT NOT NULL,
  access_condition TEXT,
  sensitivity_level TEXT,
  review_status TEXT,
  review_date DATE,
  notes TEXT,
  FOREIGN KEY (object_id) REFERENCES research_objects(object_id)
);

CREATE TABLE IF NOT EXISTS institutional_revisions (
  revision_id INTEGER PRIMARY KEY,
  object_id TEXT,
  revision_type TEXT NOT NULL,
  revision_note TEXT,
  changed_at DATE,
  FOREIGN KEY (object_id) REFERENCES research_objects(object_id)
);
