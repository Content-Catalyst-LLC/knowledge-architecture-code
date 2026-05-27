CREATE TABLE IF NOT EXISTS concepts (
  concept_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  domain TEXT,
  depth INTEGER
);

CREATE TABLE IF NOT EXISTS relationships (
  source TEXT NOT NULL,
  target TEXT NOT NULL,
  relationship TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS article_metadata (
  slug TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  series TEXT NOT NULL,
  status TEXT
);
