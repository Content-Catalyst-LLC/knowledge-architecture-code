-- Complex Systems Conceptual Model Schema
-- Minimal schema for conceptual modeling in complex systems.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS systems (
  system_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  system_type TEXT,
  scope_note TEXT,
  boundary_note TEXT,
  spatial_scale TEXT,
  temporal_scale TEXT,
  status TEXT DEFAULT 'active',
  last_reviewed DATE
);

CREATE TABLE IF NOT EXISTS components (
  component_id TEXT PRIMARY KEY,
  system_id TEXT,
  label TEXT NOT NULL,
  component_type TEXT NOT NULL,
  definition TEXT,
  scale TEXT,
  unit_note TEXT,
  uncertainty_note TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (system_id) REFERENCES systems(system_id)
);

CREATE TABLE IF NOT EXISTS relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  directionality TEXT,
  feedback_relevance INTEGER DEFAULT 0,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS model_relationships (
  relationship_id INTEGER PRIMARY KEY,
  system_id TEXT,
  source_component_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_component_id TEXT NOT NULL,
  polarity TEXT,
  delay_note TEXT,
  provenance_note TEXT,
  uncertainty_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (system_id) REFERENCES systems(system_id),
  FOREIGN KEY (source_component_id) REFERENCES components(component_id),
  FOREIGN KEY (relationship_type_id) REFERENCES relationship_types(relationship_type_id),
  FOREIGN KEY (target_component_id) REFERENCES components(component_id)
);

CREATE TABLE IF NOT EXISTS feedback_loops (
  loop_id TEXT PRIMARY KEY,
  system_id TEXT,
  loop_name TEXT NOT NULL,
  loop_type TEXT,
  description TEXT,
  evidence_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (system_id) REFERENCES systems(system_id)
);

CREATE TABLE IF NOT EXISTS loop_relationships (
  loop_id TEXT NOT NULL,
  relationship_id INTEGER NOT NULL,
  sequence_order INTEGER,
  PRIMARY KEY (loop_id, relationship_id),
  FOREIGN KEY (loop_id) REFERENCES feedback_loops(loop_id),
  FOREIGN KEY (relationship_id) REFERENCES model_relationships(relationship_id)
);

CREATE TABLE IF NOT EXISTS model_assumptions (
  assumption_id TEXT PRIMARY KEY,
  system_id TEXT,
  assumption_text TEXT NOT NULL,
  assumption_type TEXT,
  evidence_note TEXT,
  sensitivity_level TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (system_id) REFERENCES systems(system_id)
);

CREATE TABLE IF NOT EXISTS evidence_records (
  evidence_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  evidence_type TEXT,
  source_note TEXT,
  method_note TEXT,
  quality_note TEXT,
  uncertainty_note TEXT,
  access_condition TEXT
);

CREATE TABLE IF NOT EXISTS component_evidence_links (
  component_id TEXT NOT NULL,
  evidence_id TEXT NOT NULL,
  link_role TEXT,
  PRIMARY KEY (component_id, evidence_id),
  FOREIGN KEY (component_id) REFERENCES components(component_id),
  FOREIGN KEY (evidence_id) REFERENCES evidence_records(evidence_id)
);

CREATE TABLE IF NOT EXISTS scenario_records (
  scenario_id TEXT PRIMARY KEY,
  system_id TEXT,
  scenario_name TEXT NOT NULL,
  driver_note TEXT,
  assumption_note TEXT,
  outcome_note TEXT,
  uncertainty_note TEXT,
  FOREIGN KEY (system_id) REFERENCES systems(system_id)
);

CREATE TABLE IF NOT EXISTS model_revisions (
  revision_id INTEGER PRIMARY KEY,
  system_id TEXT,
  revision_type TEXT NOT NULL,
  revision_note TEXT,
  changed_at DATE,
  reviewed_by TEXT,
  FOREIGN KEY (system_id) REFERENCES systems(system_id)
);

CREATE TABLE IF NOT EXISTS governance_records (
  governance_id TEXT PRIMARY KEY,
  system_id TEXT,
  governance_type TEXT,
  review_status TEXT,
  equity_note TEXT,
  access_note TEXT,
  reviewed_at DATE,
  FOREIGN KEY (system_id) REFERENCES systems(system_id)
);
