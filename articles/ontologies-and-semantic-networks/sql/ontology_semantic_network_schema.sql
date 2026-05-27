-- Ontology and semantic-network schema for Knowledge Architecture.

CREATE TABLE IF NOT EXISTS ontology_classes (
  class_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  definition TEXT,
  parent_class_id TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (parent_class_id) REFERENCES ontology_classes(class_id)
);

CREATE TABLE IF NOT EXISTS entities (
  entity_id TEXT PRIMARY KEY,
  class_id TEXT NOT NULL,
  label TEXT NOT NULL,
  slug TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (class_id) REFERENCES ontology_classes(class_id)
);

CREATE TABLE IF NOT EXISTS properties (
  property_id TEXT PRIMARY KEY,
  label TEXT NOT NULL,
  property_type TEXT NOT NULL,
  definition TEXT,
  domain_class_id TEXT,
  range_class_id TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (domain_class_id) REFERENCES ontology_classes(class_id),
  FOREIGN KEY (range_class_id) REFERENCES ontology_classes(class_id)
);

CREATE TABLE IF NOT EXISTS semantic_relationships (
  relationship_id INTEGER PRIMARY KEY,
  subject_entity_id TEXT NOT NULL,
  property_id TEXT NOT NULL,
  object_entity_id TEXT NOT NULL,
  evidence_note TEXT,
  status TEXT DEFAULT 'active',
  FOREIGN KEY (subject_entity_id) REFERENCES entities(entity_id),
  FOREIGN KEY (property_id) REFERENCES properties(property_id),
  FOREIGN KEY (object_entity_id) REFERENCES entities(entity_id)
);

CREATE TABLE IF NOT EXISTS ontology_revisions (
  revision_id INTEGER PRIMARY KEY,
  object_type TEXT NOT NULL,
  object_id TEXT NOT NULL,
  change_type TEXT NOT NULL,
  change_note TEXT,
  changed_at DATE
);
