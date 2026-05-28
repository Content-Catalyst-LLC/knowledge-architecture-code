-- Educational Knowledge System Schema
-- Minimal schema for designing knowledge systems for education.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS concepts (
  concept_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  subject_area TEXT,
  definition TEXT,
  difficulty_level TEXT,
  prerequisite_note TEXT,
  misconception_note TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS learning_objectives (
  objective_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  objective_text TEXT NOT NULL,
  cognitive_level TEXT,
  competency_area TEXT,
  mastery_indicator TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS learning_resources (
  resource_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  resource_type TEXT,
  subject_area TEXT,
  difficulty_level TEXT,
  estimated_time_minutes INTEGER,
  license_note TEXT,
  accessibility_note TEXT,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS assessments (
  assessment_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  assessment_type TEXT,
  purpose TEXT,
  objective_id TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (objective_id) REFERENCES learning_objectives(objective_id)
);

CREATE TABLE IF NOT EXISTS rubrics (
  rubric_id TEXT PRIMARY KEY,
  assessment_id TEXT,
  title TEXT NOT NULL,
  criteria_note TEXT,
  level_description TEXT,
  FOREIGN KEY (assessment_id) REFERENCES assessments(assessment_id)
);

CREATE TABLE IF NOT EXISTS feedback_records (
  feedback_id TEXT PRIMARY KEY,
  assessment_id TEXT,
  feedback_type TEXT,
  feedback_summary TEXT,
  misconception_note TEXT,
  revision_required INTEGER DEFAULT 0,
  reviewed_at DATE,
  FOREIGN KEY (assessment_id) REFERENCES assessments(assessment_id)
);

CREATE TABLE IF NOT EXISTS accessibility_metadata (
  accessibility_id TEXT PRIMARY KEY,
  resource_id TEXT,
  has_alt_text INTEGER DEFAULT 0,
  has_captions INTEGER DEFAULT 0,
  has_transcript INTEGER DEFAULT 0,
  keyboard_accessible INTEGER DEFAULT 0,
  language_support_note TEXT,
  format_alternative_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (resource_id) REFERENCES learning_resources(resource_id)
);

CREATE TABLE IF NOT EXISTS educational_relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS educational_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  provenance_note TEXT,
  uncertainty_note TEXT,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS curriculum_maps (
  curriculum_map_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  subject_area TEXT,
  scope_note TEXT,
  sequence_note TEXT,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS repository_records (
  repository_record_id TEXT PRIMARY KEY,
  resource_id TEXT,
  repository_location TEXT,
  version_note TEXT,
  license_note TEXT,
  revision_note TEXT,
  reviewed_at DATE,
  FOREIGN KEY (resource_id) REFERENCES learning_resources(resource_id)
);

CREATE TABLE IF NOT EXISTS ai_learning_reviews (
  ai_review_id TEXT PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  review_type TEXT,
  provenance_note TEXT,
  limitation_note TEXT,
  human_review_status TEXT,
  reviewed_at DATE
);

CREATE TABLE IF NOT EXISTS governance_reviews (
  review_id TEXT PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  review_type TEXT,
  review_status TEXT,
  review_note TEXT,
  reviewed_at DATE
);
