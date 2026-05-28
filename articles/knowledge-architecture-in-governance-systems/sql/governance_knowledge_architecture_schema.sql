-- Governance Knowledge Architecture Schema
-- Minimal schema for knowledge architecture in governance systems.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS institutions (
  institution_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  institution_type TEXT,
  jurisdiction TEXT,
  mandate_note TEXT,
  accountability_note TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS governance_rules (
  rule_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  rule_type TEXT,
  jurisdiction TEXT,
  authority_source TEXT,
  effective_date DATE,
  status TEXT DEFAULT 'active',
  interpretation_note TEXT
);

CREATE TABLE IF NOT EXISTS governance_decisions (
  decision_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  institution_id TEXT,
  rule_id TEXT,
  decision_date DATE,
  decision_authority TEXT,
  rationale TEXT,
  uncertainty_note TEXT,
  review_pathway TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (institution_id) REFERENCES institutions(institution_id),
  FOREIGN KEY (rule_id) REFERENCES governance_rules(rule_id)
);

CREATE TABLE IF NOT EXISTS evidence_sources (
  evidence_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  evidence_type TEXT,
  method_note TEXT,
  source_note TEXT,
  quality_note TEXT,
  uncertainty_note TEXT,
  access_condition TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS actors (
  actor_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  actor_type TEXT,
  affected_status TEXT,
  authority_level TEXT,
  participation_status TEXT
);

CREATE TABLE IF NOT EXISTS participation_records (
  participation_id TEXT PRIMARY KEY,
  decision_id TEXT,
  actor_id TEXT,
  participation_method TEXT,
  summary TEXT,
  response_note TEXT,
  influence_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (decision_id) REFERENCES governance_decisions(decision_id),
  FOREIGN KEY (actor_id) REFERENCES actors(actor_id)
);

CREATE TABLE IF NOT EXISTS budget_records (
  budget_id TEXT PRIMARY KEY,
  decision_id TEXT,
  program_code TEXT,
  amount REAL,
  currency TEXT,
  fiscal_year TEXT,
  allocation_note TEXT,
  equity_note TEXT,
  FOREIGN KEY (decision_id) REFERENCES governance_decisions(decision_id)
);

CREATE TABLE IF NOT EXISTS outcome_indicators (
  indicator_id TEXT PRIMARY KEY,
  decision_id TEXT,
  label TEXT NOT NULL,
  definition TEXT,
  baseline_value REAL,
  current_value REAL,
  target_value REAL,
  data_source TEXT,
  limitation_note TEXT,
  FOREIGN KEY (decision_id) REFERENCES governance_decisions(decision_id)
);

CREATE TABLE IF NOT EXISTS audit_records (
  audit_id TEXT PRIMARY KEY,
  decision_id TEXT,
  audit_type TEXT,
  audit_date DATE,
  finding_summary TEXT,
  severity TEXT,
  recommendation TEXT,
  follow_up_status TEXT,
  FOREIGN KEY (decision_id) REFERENCES governance_decisions(decision_id)
);

CREATE TABLE IF NOT EXISTS revision_records (
  revision_id TEXT PRIMARY KEY,
  decision_id TEXT,
  revision_type TEXT,
  revision_date DATE,
  revision_note TEXT,
  evidence_id TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (decision_id) REFERENCES governance_decisions(decision_id),
  FOREIGN KEY (evidence_id) REFERENCES evidence_sources(evidence_id)
);

CREATE TABLE IF NOT EXISTS relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS governance_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  provenance_note TEXT,
  uncertainty_note TEXT,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS governance_review_records (
  review_id TEXT PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  review_type TEXT,
  review_status TEXT,
  review_note TEXT,
  reviewed_at DATE
);
