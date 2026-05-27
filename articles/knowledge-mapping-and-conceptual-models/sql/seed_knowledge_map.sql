-- Seed data for the Knowledge Mapping and Conceptual Models article.

INSERT OR REPLACE INTO knowledge_maps (map_id, title, purpose, domain, version, status, created_at, updated_at)
VALUES (
  'knowledge_mapping_conceptual_models',
  'Knowledge Mapping and Conceptual Models',
  'Represent concepts, relationships, evidence, pathways, and governance for knowledge architecture research.',
  'knowledge_architecture',
  '1.0.0',
  'active',
  date('now'),
  date('now')
);

INSERT OR REPLACE INTO map_concepts (concept_id, map_id, label, concept_type, domain, definition, status) VALUES
('knowledge_mapping','knowledge_mapping_conceptual_models','Knowledge Mapping','method','knowledge_architecture','Representing concepts relationships evidence pathways and gaps so a knowledge system can be reviewed and improved','active'),
('conceptual_model','knowledge_mapping_conceptual_models','Conceptual Model','model','research_design','A structured representation of how a domain problem or inquiry is understood','active'),
('taxonomy','knowledge_mapping_conceptual_models','Taxonomy','structure','classification','A controlled classification structure for categories and concepts','active'),
('ontology','knowledge_mapping_conceptual_models','Ontology','structure','semantics','A formal model of entities classes properties and relationships','active'),
('knowledge_graph','knowledge_mapping_conceptual_models','Knowledge Graph','structure','semantics','A graph representation of knowledge objects and typed semantic relationships','active'),
('metadata','knowledge_mapping_conceptual_models','Metadata','context','infrastructure','Structured contextual information supporting retrieval provenance and governance','active'),
('evidence_map','knowledge_mapping_conceptual_models','Evidence Map','evidence','research_methods','A map connecting claims concepts methods and sources to evidence','active'),
('repository','knowledge_mapping_conceptual_models','Repository','artifact','reproducibility','A structured folder of code data documentation and outputs supporting reproducible work','active'),
('ai_retrieval','knowledge_mapping_conceptual_models','AI-Assisted Retrieval','application','ai_systems','Retrieval workflows that use structured knowledge to ground AI-assisted outputs','active');
