INSERT OR REPLACE INTO frameworks (
  framework_id,
  title,
  research_problem,
  version,
  status,
  created_at,
  updated_at
) VALUES (
  'CF-KA-001',
  'Conceptual Frameworks in Research',
  'How conceptual frameworks organize concepts, relationships, assumptions, evidence, and methods in research.',
  '1.0',
  'published',
  DATE('now'),
  DATE('now')
);

INSERT OR REPLACE INTO concepts (concept_id, framework_id, label, role, domain, definition, evidence_status) VALUES
('C001','CF-KA-001','Research Problem','starting_point','research_design','The central problem or question that motivates the inquiry.','supported'),
('C002','CF-KA-001','Core Concepts','conceptual','research_design','The key ideas required to understand and frame the study.','supported'),
('C003','CF-KA-001','Assumptions','interpretive','research_design','The premises that shape interpretation and model boundaries.','provisional'),
('C004','CF-KA-001','Relationships','structural','research_design','The named connections among concepts constructs variables or mechanisms.','supported'),
('C005','CF-KA-001','Evidence','empirical','research_design','The source material data observations or documents used to support claims.','supported'),
('C006','CF-KA-001','Methods','methodological','research_design','The procedures used to collect interpret analyze or model evidence.','supported'),
('C007','CF-KA-001','Interpretation','analytical','research_design','The meaning assigned to evidence through the framework.','supported'),
('C008','CF-KA-001','Revision','governance','research_design','The process of updating the framework as evidence and understanding develop.','provisional');
