-- Scientific Collaboration Knowledge System Schema
-- Minimal schema for knowledge systems and scientific collaboration.

PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS research_projects (
  project_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  research_area TEXT,
  project_status TEXT DEFAULT 'active',
  start_date DATE,
  end_date DATE,
  governance_note TEXT
);

CREATE TABLE IF NOT EXISTS institutions (
  institution_id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  institution_type TEXT,
  country_or_region TEXT,
  role_note TEXT
);

CREATE TABLE IF NOT EXISTS contributors (
  contributor_id TEXT PRIMARY KEY,
  display_name TEXT NOT NULL,
  institution_id TEXT,
  primary_role TEXT,
  contribution_note TEXT,
  FOREIGN KEY (institution_id) REFERENCES institutions(institution_id)
);

CREATE TABLE IF NOT EXISTS contributor_roles (
  role_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  credit_note TEXT
);

CREATE TABLE IF NOT EXISTS project_contributions (
  project_id TEXT NOT NULL,
  contributor_id TEXT NOT NULL,
  role_id TEXT NOT NULL,
  contribution_detail TEXT,
  PRIMARY KEY (project_id, contributor_id, role_id),
  FOREIGN KEY (project_id) REFERENCES research_projects(project_id),
  FOREIGN KEY (contributor_id) REFERENCES contributors(contributor_id),
  FOREIGN KEY (role_id) REFERENCES contributor_roles(role_id)
);

CREATE TABLE IF NOT EXISTS datasets (
  dataset_id TEXT PRIMARY KEY,
  project_id TEXT,
  title TEXT NOT NULL,
  data_type TEXT,
  collection_method TEXT,
  license_note TEXT,
  sensitivity_note TEXT,
  metadata_status TEXT,
  provenance_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (project_id) REFERENCES research_projects(project_id)
);

CREATE TABLE IF NOT EXISTS protocols (
  protocol_id TEXT PRIMARY KEY,
  project_id TEXT,
  title TEXT NOT NULL,
  protocol_type TEXT,
  version_note TEXT,
  method_note TEXT,
  deviation_note TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (project_id) REFERENCES research_projects(project_id)
);

CREATE TABLE IF NOT EXISTS software_artifacts (
  software_id TEXT PRIMARY KEY,
  project_id TEXT,
  title TEXT NOT NULL,
  software_type TEXT,
  repository_url TEXT,
  environment_note TEXT,
  license_note TEXT,
  test_status TEXT,
  review_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (project_id) REFERENCES research_projects(project_id)
);

CREATE TABLE IF NOT EXISTS publications (
  publication_id TEXT PRIMARY KEY,
  project_id TEXT,
  title TEXT NOT NULL,
  publication_type TEXT,
  doi TEXT,
  publication_status TEXT,
  version_note TEXT,
  correction_status TEXT,
  FOREIGN KEY (project_id) REFERENCES research_projects(project_id)
);

CREATE TABLE IF NOT EXISTS ethics_records (
  ethics_id TEXT PRIMARY KEY,
  project_id TEXT,
  ethics_type TEXT,
  approval_status TEXT,
  consent_note TEXT,
  data_use_note TEXT,
  review_date DATE,
  FOREIGN KEY (project_id) REFERENCES research_projects(project_id)
);

CREATE TABLE IF NOT EXISTS collaboration_relationship_types (
  relationship_type_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS collaboration_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_object_id TEXT NOT NULL,
  relationship_type_id TEXT NOT NULL,
  target_object_id TEXT NOT NULL,
  provenance_note TEXT,
  uncertainty_note TEXT,
  review_status TEXT DEFAULT 'provisional'
);

CREATE TABLE IF NOT EXISTS peer_review_records (
  review_id TEXT PRIMARY KEY,
  publication_id TEXT,
  review_type TEXT,
  review_status TEXT,
  review_note TEXT,
  response_note TEXT,
  reviewed_at DATE,
  FOREIGN KEY (publication_id) REFERENCES publications(publication_id)
);

CREATE TABLE IF NOT EXISTS revision_records (
  revision_id TEXT PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  revision_type TEXT,
  revision_note TEXT,
  prior_version TEXT,
  revised_version TEXT,
  changed_at DATE,
  reviewed_by TEXT
);
