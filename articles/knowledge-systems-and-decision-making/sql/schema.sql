CREATE TABLE IF NOT EXISTS concepts (
  concept_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  domain TEXT NOT NULL,
  level INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS relationships (
  source TEXT NOT NULL,
  target TEXT NOT NULL,
  relationship TEXT NOT NULL
);
