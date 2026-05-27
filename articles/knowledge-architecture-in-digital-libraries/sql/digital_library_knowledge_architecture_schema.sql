PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS digital_objects (
  object_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  object_type TEXT NOT NULL,
  identifier TEXT,
  status TEXT DEFAULT 'active',
  created_at DATE,
  updated_at DATE,
  last_reviewed DATE
);

CREATE TABLE IF NOT EXISTS collections (
  collection_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  scope_note TEXT,
  provenance_note TEXT,
  access_note TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS object_collection_links (
  object_id TEXT NOT NULL,
  collection_id TEXT NOT NULL,
  relationship_role TEXT DEFAULT 'member',
  PRIMARY KEY (object_id, collection_id),
  FOREIGN KEY (object_id) REFERENCES digital_objects(object_id),
  FOREIGN KEY (collection_id) REFERENCES collections(collection_id)
);

CREATE TABLE IF NOT EXISTS object_metadata (
  object_id TEXT NOT NULL,
  field_id TEXT NOT NULL,
  value TEXT,
  provenance_note TEXT,
  PRIMARY KEY (object_id, field_id),
  FOREIGN KEY (object_id) REFERENCES digital_objects(object_id)
);

CREATE TABLE IF NOT EXISTS authority_records (
  authority_id TEXT PRIMARY KEY,
  preferred_label TEXT NOT NULL,
  authority_type TEXT,
  alternate_labels TEXT,
  source_vocab TEXT,
  scope_note TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS subject_terms (
  subject_id TEXT PRIMARY KEY,
  preferred_label TEXT NOT NULL,
  broader_subject_id TEXT,
  scope_note TEXT,
  source_vocab TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (broader_subject_id) REFERENCES subject_terms(subject_id)
);

CREATE TABLE IF NOT EXISTS rights_records (
  rights_id TEXT PRIMARY KEY,
  rights_label TEXT NOT NULL,
  rights_uri TEXT,
  access_condition TEXT,
  reuse_condition TEXT,
  sensitivity_note TEXT
);

CREATE TABLE IF NOT EXISTS preservation_events (
  event_id TEXT PRIMARY KEY,
  object_id TEXT NOT NULL,
  event_type TEXT NOT NULL,
  event_date DATE,
  agent TEXT,
  outcome TEXT,
  notes TEXT,
  FOREIGN KEY (object_id) REFERENCES digital_objects(object_id)
);

CREATE TABLE IF NOT EXISTS description_revisions (
  revision_id INTEGER PRIMARY KEY,
  object_id TEXT,
  revision_type TEXT NOT NULL,
  revision_note TEXT,
  changed_at DATE,
  changed_by TEXT,
  FOREIGN KEY (object_id) REFERENCES digital_objects(object_id)
);
