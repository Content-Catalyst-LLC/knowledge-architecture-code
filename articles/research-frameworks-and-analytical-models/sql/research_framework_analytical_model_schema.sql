-- Research Framework and Analytical Model Schema

CREATE TABLE IF NOT EXISTS research_frameworks (
  framework_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  research_problem TEXT NOT NULL,
  domain TEXT,
  version TEXT,
  status TEXT DEFAULT 'draft',
  created_at DATE,
  updated_at DATE
);

CREATE TABLE IF NOT EXISTS model_elements (
  element_id TEXT PRIMARY KEY,
  framework_id TEXT NOT NULL,
  label TEXT NOT NULL,
  element_type TEXT,
  role TEXT,
  definition TEXT,
  evidence_status TEXT DEFAULT 'provisional',
  FOREIGN KEY (framework_id) REFERENCES research_frameworks(framework_id)
);

CREATE TABLE IF NOT EXISTS model_relationships (
  relationship_id INTEGER PRIMARY KEY,
  framework_id TEXT NOT NULL,
  source_element_id TEXT NOT NULL,
  target_element_id TEXT NOT NULL,
  relationship_type TEXT NOT NULL,
  assumption_note TEXT,
  documented BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (framework_id) REFERENCES research_frameworks(framework_id),
  FOREIGN KEY (source_element_id) REFERENCES model_elements(element_id),
  FOREIGN KEY (target_element_id) REFERENCES model_elements(element_id)
);

CREATE TABLE IF NOT EXISTS evidence_sources (
  evidence_id TEXT PRIMARY KEY,
  citation TEXT NOT NULL,
  source_type TEXT,
  url TEXT,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS methods (
  method_id TEXT PRIMARY KEY,
  framework_id TEXT NOT NULL,
  method_name TEXT NOT NULL,
  method_type TEXT,
  purpose TEXT,
  limitations TEXT,
  FOREIGN KEY (framework_id) REFERENCES research_frameworks(framework_id)
);

CREATE TABLE IF NOT EXISTS element_evidence (
  element_id TEXT NOT NULL,
  evidence_id TEXT NOT NULL,
  evidence_role TEXT,
  PRIMARY KEY (element_id, evidence_id),
  FOREIGN KEY (element_id) REFERENCES model_elements(element_id),
  FOREIGN KEY (evidence_id) REFERENCES evidence_sources(evidence_id)
);
