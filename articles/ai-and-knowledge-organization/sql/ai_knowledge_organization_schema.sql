-- AI Knowledge Organization Schema
-- Minimal schema for AI and knowledge organization.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS knowledge_objects (
  object_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  object_type TEXT NOT NULL,
  source_type TEXT,
  created_at DATE,
  updated_at DATE,
  version_note TEXT,
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

CREATE TABLE IF NOT EXISTS ontology_classes (
  class_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  parent_class_id TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (parent_class_id) REFERENCES ontology_classes(class_id)
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

CREATE TABLE IF NOT EXISTS embedding_indexes (
  index_id TEXT PRIMARY KEY,
  index_name TEXT NOT NULL,
  embedding_model_note TEXT,
  corpus_scope_note TEXT,
  chunking_strategy_note TEXT,
  created_at DATE,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS retrieval_records (
  retrieval_id TEXT PRIMARY KEY,
  index_id TEXT,
  query_text TEXT,
  retrieved_object_id TEXT,
  rank_position INTEGER,
  relevance_note TEXT,
  reviewed INTEGER DEFAULT 0,
  FOREIGN KEY (index_id) REFERENCES embedding_indexes(index_id),
  FOREIGN KEY (retrieved_object_id) REFERENCES knowledge_objects(object_id)
);

CREATE TABLE IF NOT EXISTS ai_outputs (
  output_id TEXT PRIMARY KEY,
  output_type TEXT,
  prompt_note TEXT,
  model_note TEXT,
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

CREATE TABLE IF NOT EXISTS source_hierarchy_rules (
  rule_id TEXT PRIMARY KEY,
  domain TEXT,
  source_type TEXT,
  authority_rank INTEGER,
  rule_note TEXT,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS human_review_records (
  review_id TEXT PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  review_type TEXT,
  review_status TEXT,
  review_note TEXT,
  reviewed_at DATE
);

CREATE TABLE IF NOT EXISTS correction_records (
  correction_id TEXT PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  correction_type TEXT,
  correction_note TEXT,
  prior_value TEXT,
  revised_value TEXT,
  changed_at DATE,
  reviewed_by TEXT
);
