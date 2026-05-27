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
