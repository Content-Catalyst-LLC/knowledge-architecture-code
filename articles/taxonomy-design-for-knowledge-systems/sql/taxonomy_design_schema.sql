-- Taxonomy Design for Knowledge Systems
-- Controlled vocabulary, relationship, assignment, and revision schema.

CREATE TABLE IF NOT EXISTS taxonomy_terms (
  term_id TEXT PRIMARY KEY,
  preferred_label TEXT NOT NULL,
  parent_id TEXT,
  depth INTEGER,
  facet TEXT,
  scope_note TEXT,
  status TEXT DEFAULT 'active',
  created_at DATE,
  updated_at DATE,
  FOREIGN KEY (parent_id) REFERENCES taxonomy_terms(term_id)
);

CREATE TABLE IF NOT EXISTS alternate_terms (
  alternate_id INTEGER PRIMARY KEY,
  term_id TEXT NOT NULL,
  alternate_label TEXT NOT NULL,
  alternate_type TEXT,
  FOREIGN KEY (term_id) REFERENCES taxonomy_terms(term_id)
);

CREATE TABLE IF NOT EXISTS taxonomy_relationships (
  relationship_id INTEGER PRIMARY KEY,
  source_term_id TEXT NOT NULL,
  target_term_id TEXT NOT NULL,
  relationship_type TEXT NOT NULL,
  note TEXT,
  FOREIGN KEY (source_term_id) REFERENCES taxonomy_terms(term_id),
  FOREIGN KEY (target_term_id) REFERENCES taxonomy_terms(term_id)
);

CREATE TABLE IF NOT EXISTS knowledge_objects (
  object_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  object_type TEXT,
  slug TEXT,
  status TEXT DEFAULT 'active'
);

CREATE TABLE IF NOT EXISTS term_assignments (
  object_id TEXT NOT NULL,
  term_id TEXT NOT NULL,
  assignment_type TEXT DEFAULT 'primary',
  assigned_at DATE,
  PRIMARY KEY (object_id, term_id),
  FOREIGN KEY (object_id) REFERENCES knowledge_objects(object_id),
  FOREIGN KEY (term_id) REFERENCES taxonomy_terms(term_id)
);

CREATE TABLE IF NOT EXISTS taxonomy_revisions (
  revision_id INTEGER PRIMARY KEY,
  term_id TEXT,
  change_type TEXT NOT NULL,
  change_note TEXT,
  changed_at DATE,
  FOREIGN KEY (term_id) REFERENCES taxonomy_terms(term_id)
);
