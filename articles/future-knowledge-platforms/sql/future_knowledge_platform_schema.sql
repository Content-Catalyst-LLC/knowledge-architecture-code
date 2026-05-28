-- Future Knowledge Platform Schema
-- Minimal schema for future knowledge platforms.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS knowledge_objects (
  object_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  object_type TEXT NOT NULL,
  slug TEXT,
  status TEXT DEFAULT 'active',
  created_at DATE,
  updated_at DATE,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS metadata_fields (
  field_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  required INTEGER DEFAULT 0,
  field_type TEXT,
  governance_note TEXT
);

CREATE TABLE IF NOT EXISTS object_metadata_values (
  object_id TEXT NOT NULL,
  field_id TEXT NOT NULL,
  value_text TEXT,
  provenance_note TEXT,
  PRIMARY KEY (object_id, field_id),
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id),
  FOREIGN KEY (field_id) REFERENCES metadata_fields(field_id)
);

CREATE TABLE IF NOT EXISTS taxonomy_terms (
  term_id TEXT PRIMARY KEY,
  preferred_label TEXT NOT NULL,
  alternative_labels TEXT,
  scope_note TEXT,
  broader_term_id TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (broader_term_id) REFERENCES taxonomy_terms(term_id)
);

CREATE TABLE IF NOT EXISTS relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  inverse_label TEXT,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS knowledge_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  provenance_note TEXT,
  uncertainty_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (source_object_id) REFERENCES knowledge_objects(object_id),
  FOREIGN KEY (relationship_type_id) REFERENCES relationship_types(relationship_type_id),
  FOREIGN KEY (target_object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS repositories (
  repository_id TEXT PRIMARY KEY,
  object_id TEXT,
  repository_url TEXT,
  repository_type TEXT,
  license_note TEXT,
  readme_status TEXT,
  reproducibility_status TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS ai_retrieval_records (
  retrieval_id TEXT PRIMARY KEY,
  query_text TEXT,
  retrieved_object_id TEXT,
  rank_position INTEGER,
  grounding_note TEXT,
  reviewed INTEGER DEFAULT 0,
  created_at DATE,
  FOREIGN KEY (retrieved_object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS ai_outputs (
  output_id TEXT PRIMARY KEY,
  output_type TEXT,
  prompt_note TEXT,
  grounding_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  created_at DATE
);

CREATE TABLE IF NOT EXISTS output_source_links (
  output_id TEXT NOT NULL,
  object_id TEXT NOT NULL,
  link_role TEXT,
  citation_note TEXT,
  PRIMARY KEY (output_id, object_id),
  FOREIGN KEY (output_id) REFERENCES ai_outputs(output_id),
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS governance_records (
  governance_id TEXT PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  governance_type TEXT,
  governance_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  reviewed_at DATE
);

CREATE TABLE IF NOT EXISTS accessibility_records (
  accessibility_id TEXT PRIMARY KEY,
  object_id TEXT,
  has_alt_text INTEGER DEFAULT 0,
  has_captions INTEGER DEFAULT 0,
  has_transcript INTEGER DEFAULT 0,
  semantic_structure_status TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS revision_records (
  revision_id TEXT PRIMARY KEY,
  object_id TEXT,
  revision_type TEXT,
  prior_status TEXT,
  revised_status TEXT,
  revision_note TEXT,
  changed_at DATE,
  reviewed_by TEXT,
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS reuse_conditions (
  reuse_id TEXT PRIMARY KEY,
  object_id TEXT,
  license_note TEXT,
  attribution_note TEXT,
  sensitivity_note TEXT,
  access_condition TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS resilience_records (
  resilience_id TEXT PRIMARY KEY,
  object_id TEXT,
  resilience_type TEXT,
  resilience_status TEXT,
  risk_note TEXT,
  stewardship_action TEXT,
  reviewed_at DATE,
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id)
);
