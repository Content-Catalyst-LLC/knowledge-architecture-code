-- conceptual_framework_schema.sql
-- Minimal schema for concepts, relationships, evidence, and framework versions.

CREATE TABLE IF NOT EXISTS frameworks (
  framework_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  research_problem TEXT,
  version TEXT,
  status TEXT DEFAULT 'draft',
  created_at DATE,
  updated_at DATE
);

CREATE TABLE IF NOT EXISTS concepts (
  concept_id TEXT PRIMARY KEY,
  framework_id TEXT NOT NULL,
  label TEXT NOT NULL,
  role TEXT,
  domain TEXT,
  definition TEXT,
  evidence_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (framework_id) REFERENCES frameworks(framework_id)
);

CREATE TABLE IF NOT EXISTS relationships (
  relationship_id INTEGER PRIMARY KEY,
  framework_id TEXT NOT NULL,
  source_concept_id TEXT NOT NULL,
  target_concept_id TEXT NOT NULL,
  relationship_type TEXT NOT NULL,
  assumption_note TEXT,
  FOREIGN KEY (framework_id) REFERENCES frameworks(framework_id),
  FOREIGN KEY (source_concept_id) REFERENCES concepts(concept_id),
  FOREIGN KEY (target_concept_id) REFERENCES concepts(concept_id)
);

CREATE TABLE IF NOT EXISTS evidence_sources (
  evidence_id TEXT PRIMARY KEY,
  citation TEXT NOT NULL,
  source_type TEXT,
  url TEXT,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS concept_evidence (
  concept_id TEXT NOT NULL,
  evidence_id TEXT NOT NULL,
  evidence_role TEXT,
  PRIMARY KEY (concept_id, evidence_id),
  FOREIGN KEY (concept_id) REFERENCES concepts(concept_id),
  FOREIGN KEY (evidence_id) REFERENCES evidence_sources(evidence_id)
);
