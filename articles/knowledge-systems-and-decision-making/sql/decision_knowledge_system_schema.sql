-- Decision Knowledge System Schema
-- Minimal schema for knowledge systems and decision-making.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS decision_questions (
  question_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  problem_statement TEXT,
  decision_context TEXT,
  jurisdiction_or_domain TEXT,
  affected_population TEXT,
  status TEXT DEFAULT 'active',
  created_at DATE,
  last_reviewed DATE
);

CREATE TABLE IF NOT EXISTS evidence_sources (
  evidence_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  evidence_type TEXT NOT NULL,
  source_note TEXT,
  method_note TEXT,
  quality_note TEXT,
  uncertainty_note TEXT,
  equity_note TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS decision_options (
  option_id TEXT PRIMARY KEY,
  question_id TEXT,
  title TEXT NOT NULL,
  option_type TEXT,
  rationale TEXT,
  implementation_note TEXT,
  risk_note TEXT,
  equity_note TEXT,
  status TEXT DEFAULT 'proposed',
  FOREIGN KEY (question_id) REFERENCES decision_questions(question_id)
);

CREATE TABLE IF NOT EXISTS decision_criteria (
  criterion_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  criterion_type TEXT,
  weight REAL,
  value_note TEXT
);

CREATE TABLE IF NOT EXISTS option_criteria_scores (
  option_id TEXT NOT NULL,
  criterion_id TEXT NOT NULL,
  score REAL,
  score_note TEXT,
  evidence_id TEXT,
  PRIMARY KEY (option_id, criterion_id),
  FOREIGN KEY (option_id) REFERENCES decision_options(option_id),
  FOREIGN KEY (criterion_id) REFERENCES decision_criteria(criterion_id),
  FOREIGN KEY (evidence_id) REFERENCES evidence_sources(evidence_id)
);

CREATE TABLE IF NOT EXISTS actors (
  actor_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  actor_type TEXT,
  authority_note TEXT,
  affected_status TEXT,
  participation_status TEXT
);

CREATE TABLE IF NOT EXISTS decision_records (
  decision_id TEXT PRIMARY KEY,
  question_id TEXT,
  selected_option_id TEXT,
  decision_date DATE,
  decision_authority TEXT,
  rationale TEXT,
  uncertainty_note TEXT,
  review_status TEXT,
  FOREIGN KEY (question_id) REFERENCES decision_questions(question_id),
  FOREIGN KEY (selected_option_id) REFERENCES decision_options(option_id)
);

CREATE TABLE IF NOT EXISTS assumptions (
  assumption_id TEXT PRIMARY KEY,
  question_id TEXT,
  assumption_text TEXT NOT NULL,
  assumption_type TEXT,
  sensitivity_level TEXT,
  review_status TEXT,
  FOREIGN KEY (question_id) REFERENCES decision_questions(question_id)
);

CREATE TABLE IF NOT EXISTS outcome_indicators (
  indicator_id TEXT PRIMARY KEY,
  decision_id TEXT,
  label TEXT NOT NULL,
  definition TEXT,
  baseline_value REAL,
  target_value REAL,
  current_value REAL,
  data_source TEXT,
  limitation_note TEXT,
  FOREIGN KEY (decision_id) REFERENCES decision_records(decision_id)
);

CREATE TABLE IF NOT EXISTS feedback_records (
  feedback_id TEXT PRIMARY KEY,
  decision_id TEXT,
  feedback_type TEXT,
  source_note TEXT,
  feedback_summary TEXT,
  equity_note TEXT,
  action_required INTEGER DEFAULT 0,
  reviewed_at DATE,
  FOREIGN KEY (decision_id) REFERENCES decision_records(decision_id)
);

CREATE TABLE IF NOT EXISTS relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS decision_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  provenance_note TEXT,
  uncertainty_note TEXT,
  review_status TEXT DEFAULT 'provisional'
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
