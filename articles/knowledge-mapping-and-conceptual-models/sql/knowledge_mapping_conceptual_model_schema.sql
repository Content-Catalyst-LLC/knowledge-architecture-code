-- Knowledge Mapping and Conceptual Models
-- Professional schema for knowledge maps, conceptual models, concepts, relationships, evidence, pathways, and revisions.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS knowledge_maps (
  map_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  purpose TEXT,
  domain TEXT,
  version TEXT,
  status TEXT DEFAULT 'draft',
  created_at TEXT,
  updated_at TEXT
);

CREATE TABLE IF NOT EXISTS map_concepts (
  concept_id TEXT PRIMARY KEY,
  map_id TEXT NOT NULL,
  label TEXT NOT NULL,
  concept_type TEXT,
  domain TEXT,
  definition TEXT,
  scope_note TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (map_id) REFERENCES knowledge_maps(map_id)
);

CREATE TABLE IF NOT EXISTS map_relationships (
  relationship_id INTEGER PRIMARY KEY,
  map_id TEXT NOT NULL,
  source_concept_id TEXT NOT NULL,
  target_concept_id TEXT NOT NULL,
  relationship_type TEXT NOT NULL,
  evidence_status TEXT DEFAULT 'provisional',
  provenance_note TEXT,
  notes TEXT,
  FOREIGN KEY (map_id) REFERENCES knowledge_maps(map_id),
  FOREIGN KEY (source_concept_id) REFERENCES map_concepts(concept_id),
  FOREIGN KEY (target_concept_id) REFERENCES map_concepts(concept_id)
);

CREATE TABLE IF NOT EXISTS evidence_sources (
  evidence_id TEXT PRIMARY KEY,
  citation TEXT NOT NULL,
  source_type TEXT,
  url TEXT,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS relationship_evidence (
  relationship_id INTEGER NOT NULL,
  evidence_id TEXT NOT NULL,
  evidence_role TEXT,
  PRIMARY KEY (relationship_id, evidence_id),
  FOREIGN KEY (relationship_id) REFERENCES map_relationships(relationship_id),
  FOREIGN KEY (evidence_id) REFERENCES evidence_sources(evidence_id)
);

CREATE TABLE IF NOT EXISTS map_pathways (
  pathway_id TEXT,
  step_order INTEGER,
  map_id TEXT NOT NULL,
  concept_id TEXT NOT NULL,
  pathway_type TEXT,
  description TEXT,
  PRIMARY KEY (pathway_id, step_order),
  FOREIGN KEY (map_id) REFERENCES knowledge_maps(map_id),
  FOREIGN KEY (concept_id) REFERENCES map_concepts(concept_id)
);

CREATE TABLE IF NOT EXISTS map_revisions (
  revision_id INTEGER PRIMARY KEY,
  map_id TEXT NOT NULL,
  change_type TEXT NOT NULL,
  change_note TEXT,
  changed_at TEXT,
  FOREIGN KEY (map_id) REFERENCES knowledge_maps(map_id)
);
