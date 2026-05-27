-- Interdisciplinary Knowledge Structure Schema
-- Minimal schema for disciplines, concepts, methods, evidence types, crosswalks, articles, repositories, and governance.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS disciplines (
  discipline_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  scope_note TEXT,
  parent_discipline_id TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (parent_discipline_id) REFERENCES disciplines(discipline_id)
);

CREATE TABLE IF NOT EXISTS concepts (
  concept_id TEXT PRIMARY KEY,
  preferred_label TEXT NOT NULL,
  discipline_id TEXT,
  definition TEXT,
  scope_note TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (discipline_id) REFERENCES disciplines(discipline_id)
);

CREATE TABLE IF NOT EXISTS methods (
  method_id TEXT PRIMARY KEY,
  method_name TEXT NOT NULL,
  discipline_id TEXT,
  method_type TEXT,
  assumptions TEXT,
  limitations TEXT,
  FOREIGN KEY (discipline_id) REFERENCES disciplines(discipline_id)
);

CREATE TABLE IF NOT EXISTS evidence_types (
  evidence_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  description TEXT,
  typical_disciplines TEXT,
  review_note TEXT
);

CREATE TABLE IF NOT EXISTS concept_method_links (
  concept_id TEXT NOT NULL,
  method_id TEXT NOT NULL,
  relationship_role TEXT,
  PRIMARY KEY (concept_id, method_id),
  FOREIGN KEY (concept_id) REFERENCES concepts(concept_id),
  FOREIGN KEY (method_id) REFERENCES methods(method_id)
);

CREATE TABLE IF NOT EXISTS crosswalk_relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  false_equivalence_risk TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS concept_crosswalks (
  crosswalk_id INTEGER PRIMARY KEY,
  source_concept_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_concept_id TEXT NOT NULL,
  provenance_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (source_concept_id) REFERENCES concepts(concept_id),
  FOREIGN KEY (relationship_type_id) REFERENCES crosswalk_relationship_types(relationship_type_id),
  FOREIGN KEY (target_concept_id) REFERENCES concepts(concept_id)
);

CREATE TABLE IF NOT EXISTS articles (
  article_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  slug TEXT,
  primary_discipline_id TEXT,
  article_type TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (primary_discipline_id) REFERENCES disciplines(discipline_id)
);

CREATE TABLE IF NOT EXISTS article_concepts (
  article_id TEXT NOT NULL,
  concept_id TEXT NOT NULL,
  concept_role TEXT,
  PRIMARY KEY (article_id, concept_id),
  FOREIGN KEY (article_id) REFERENCES articles(article_id),
  FOREIGN KEY (concept_id) REFERENCES concepts(concept_id)
);

CREATE TABLE IF NOT EXISTS governance_reviews (
  review_id INTEGER PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  review_type TEXT NOT NULL,
  review_status TEXT,
  review_note TEXT,
  reviewed_at DATE
);
