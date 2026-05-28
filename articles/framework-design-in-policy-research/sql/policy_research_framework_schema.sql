-- Policy Research Framework Schema
-- Minimal schema for framework design in policy research.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS policy_problems (
  problem_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  problem_statement TEXT,
  jurisdiction TEXT,
  affected_population TEXT,
  scope_note TEXT,
  status TEXT DEFAULT 'active',
  last_reviewed DATE
);

CREATE TABLE IF NOT EXISTS evidence_sources (
  evidence_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  evidence_type TEXT NOT NULL,
  method_note TEXT,
  source_url TEXT,
  quality_note TEXT,
  uncertainty_note TEXT,
  equity_note TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS stakeholders (
  stakeholder_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  stakeholder_type TEXT,
  role_note TEXT,
  affected_status TEXT,
  authority_level TEXT,
  participation_status TEXT
);

CREATE TABLE IF NOT EXISTS institutions (
  institution_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  institution_type TEXT,
  jurisdiction TEXT,
  authority_note TEXT,
  capacity_note TEXT,
  accountability_note TEXT
);

CREATE TABLE IF NOT EXISTS policy_options (
  option_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  problem_id TEXT,
  intervention_type TEXT,
  theory_of_change TEXT,
  implementation_note TEXT,
  risk_note TEXT,
  equity_note TEXT,
  status TEXT DEFAULT 'proposed',
  FOREIGN KEY (problem_id) REFERENCES policy_problems(problem_id)
);

CREATE TABLE IF NOT EXISTS decision_criteria (
  criterion_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  criterion_type TEXT,
  weight REAL,
  value_note TEXT
);

CREATE TABLE IF NOT EXISTS option_scores (
  option_id TEXT NOT NULL,
  criterion_id TEXT NOT NULL,
  score REAL,
  score_note TEXT,
  evidence_id TEXT,
  PRIMARY KEY (option_id, criterion_id),
  FOREIGN KEY (option_id) REFERENCES policy_options(option_id),
  FOREIGN KEY (criterion_id) REFERENCES decision_criteria(criterion_id),
  FOREIGN KEY (evidence_id) REFERENCES evidence_sources(evidence_id)
);

CREATE TABLE IF NOT EXISTS indicators (
  indicator_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  unit TEXT,
  baseline_value REAL,
  target_value REAL,
  data_source TEXT,
  disaggregation_note TEXT,
  limitation_note TEXT
);

CREATE TABLE IF NOT EXISTS framework_relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS framework_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  provenance_note TEXT,
  uncertainty_note TEXT,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS evaluation_plans (
  evaluation_id TEXT PRIMARY KEY,
  option_id TEXT,
  evaluation_type TEXT,
  evaluation_question TEXT,
  design_note TEXT,
  indicator_id TEXT,
  learning_use TEXT,
  review_date DATE,
  FOREIGN KEY (option_id) REFERENCES policy_options(option_id),
  FOREIGN KEY (indicator_id) REFERENCES indicators(indicator_id)
);

CREATE TABLE IF NOT EXISTS governance_records (
  governance_id TEXT PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  governance_type TEXT,
  review_status TEXT,
  review_note TEXT,
  reviewed_at DATE
);
