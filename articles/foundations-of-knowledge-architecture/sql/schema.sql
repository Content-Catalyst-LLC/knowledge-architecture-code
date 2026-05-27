-- Knowledge architecture schema for concept, relationship, article, and metadata modeling.

CREATE TABLE IF NOT EXISTS concepts (
  concept_id TEXT PRIMARY KEY,
  label TEXT NOT NULL UNIQUE,
  domain TEXT NOT NULL,
  depth INTEGER NOT NULL CHECK (depth >= 0),
  status TEXT NOT NULL CHECK (status IN ('core', 'applied', 'planned', 'archived'))
);

CREATE TABLE IF NOT EXISTS relationships (
  relationship_id INTEGER PRIMARY KEY AUTOINCREMENT,
  source TEXT NOT NULL,
  target TEXT NOT NULL,
  relationship TEXT NOT NULL,
  weight REAL NOT NULL CHECK (weight >= 0 AND weight <= 1),
  FOREIGN KEY (source) REFERENCES concepts(label),
  FOREIGN KEY (target) REFERENCES concepts(label)
);

CREATE TABLE IF NOT EXISTS articles (
  slug TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  series TEXT NOT NULL,
  status TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS article_concepts (
  slug TEXT NOT NULL,
  concept_id TEXT NOT NULL,
  role TEXT NOT NULL,
  PRIMARY KEY (slug, concept_id),
  FOREIGN KEY (slug) REFERENCES articles(slug),
  FOREIGN KEY (concept_id) REFERENCES concepts(concept_id)
);

CREATE TABLE IF NOT EXISTS metadata_fields (
  field_name TEXT PRIMARY KEY,
  field_type TEXT NOT NULL,
  required INTEGER NOT NULL CHECK (required IN (0, 1)),
  description TEXT
);
