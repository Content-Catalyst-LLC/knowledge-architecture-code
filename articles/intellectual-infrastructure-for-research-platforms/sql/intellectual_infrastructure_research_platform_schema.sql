-- Intellectual Infrastructure for Research Platforms
-- Minimal schema for platform objects, metadata, taxonomies, relationships, repositories, governance, and revisions.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS platform_objects (
  object_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  object_type TEXT NOT NULL,
  slug TEXT,
  status TEXT DEFAULT 'active',
  created_at DATE,
  updated_at DATE,
  last_reviewed DATE
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
  FOREIGN KEY (object_id) REFERENCES platform_objects(object_id),
  FOREIGN KEY (field_id) REFERENCES metadata_fields(field_id)
);

CREATE TABLE IF NOT EXISTS taxonomy_terms (
  term_id TEXT PRIMARY KEY,
  preferred_label TEXT NOT NULL,
  scope_note TEXT,
  parent_term_id TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (parent_term_id) REFERENCES taxonomy_terms(term_id)
);

CREATE TABLE IF NOT EXISTS object_taxonomy_assignments (
  object_id TEXT NOT NULL,
  term_id TEXT NOT NULL,
  assignment_type TEXT DEFAULT 'primary',
  PRIMARY KEY (object_id, term_id),
  FOREIGN KEY (object_id) REFERENCES platform_objects(object_id),
  FOREIGN KEY (term_id) REFERENCES taxonomy_terms(term_id)
);

CREATE TABLE IF NOT EXISTS relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  domain_object_type TEXT,
  range_object_type TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS platform_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  provenance_note TEXT,
  confidence_level TEXT DEFAULT 'provisional',
  status TEXT DEFAULT 'active',
  FOREIGN KEY (source_object_id) REFERENCES platform_objects(object_id),
  FOREIGN KEY (relationship_type_id) REFERENCES relationship_types(relationship_type_id),
  FOREIGN KEY (target_object_id) REFERENCES platform_objects(object_id)
);

CREATE TABLE IF NOT EXISTS repositories (
  repository_id TEXT PRIMARY KEY,
  repository_url TEXT NOT NULL,
  local_path TEXT,
  repository_role TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS object_repository_links (
  object_id TEXT NOT NULL,
  repository_id TEXT NOT NULL,
  repository_role TEXT,
  PRIMARY KEY (object_id, repository_id),
  FOREIGN KEY (object_id) REFERENCES platform_objects(object_id),
  FOREIGN KEY (repository_id) REFERENCES repositories(repository_id)
);

CREATE TABLE IF NOT EXISTS governance_records (
  governance_id TEXT PRIMARY KEY,
  object_id TEXT,
  governance_type TEXT NOT NULL,
  review_status TEXT,
  sensitivity_level TEXT,
  notes TEXT,
  review_date DATE,
  FOREIGN KEY (object_id) REFERENCES platform_objects(object_id)
);

CREATE TABLE IF NOT EXISTS platform_revisions (
  revision_id INTEGER PRIMARY KEY,
  object_id TEXT,
  revision_type TEXT NOT NULL,
  revision_note TEXT,
  changed_at DATE,
  FOREIGN KEY (object_id) REFERENCES platform_objects(object_id)
);
