-- What Is Knowledge Architecture?
-- Concept, article, relationship, metadata, and governance schema.

CREATE TABLE IF NOT EXISTS concepts (
  concept_id TEXT PRIMARY KEY,
  label TEXT NOT NULL UNIQUE,
  domain TEXT NOT NULL,
  depth INTEGER NOT NULL,
  status TEXT DEFAULT 'active',
  definition TEXT
);

CREATE TABLE IF NOT EXISTS articles (
  article_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  series TEXT NOT NULL,
  status TEXT DEFAULT 'draft',
  last_reviewed DATE
);

CREATE TABLE IF NOT EXISTS relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_label TEXT NOT NULL,
  target_label TEXT NOT NULL,
  relationship_type TEXT NOT NULL,
  evidence_note TEXT,
  FOREIGN KEY (source_label) REFERENCES concepts(label),
  FOREIGN KEY (target_label) REFERENCES concepts(label)
);

CREATE TABLE IF NOT EXISTS article_concepts (
  article_id TEXT NOT NULL,
  concept_id TEXT NOT NULL,
  role TEXT DEFAULT 'mentioned',
  PRIMARY KEY (article_id, concept_id),
  FOREIGN KEY (article_id) REFERENCES articles(article_id),
  FOREIGN KEY (concept_id) REFERENCES concepts(concept_id)
);

CREATE TABLE IF NOT EXISTS metadata_fields (
  field_name TEXT PRIMARY KEY,
  purpose TEXT NOT NULL,
  required INTEGER DEFAULT 0,
  example TEXT
);

CREATE TABLE IF NOT EXISTS governance_events (
  event_id INTEGER PRIMARY KEY,
  event_date DATE NOT NULL,
  event_type TEXT NOT NULL,
  description TEXT NOT NULL,
  affected_object TEXT
);
