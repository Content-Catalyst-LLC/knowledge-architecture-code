-- Sample queries for knowledge architecture review.

-- Concepts by domain.
SELECT domain, COUNT(*) AS concept_count
FROM concepts
GROUP BY domain
ORDER BY concept_count DESC, domain;

-- Relationship type distribution.
SELECT relationship_type, COUNT(*) AS relationship_count
FROM relationships
GROUP BY relationship_type
ORDER BY relationship_count DESC, relationship_type;

-- Potential architecture hubs.
SELECT label, COUNT(*) AS degree
FROM (
  SELECT source_label AS label FROM relationships
  UNION ALL
  SELECT target_label AS label FROM relationships
)
GROUP BY label
ORDER BY degree DESC, label;

-- Articles and concept mappings.
SELECT a.title, c.label, ac.role
FROM article_concepts ac
JOIN articles a ON a.article_id = ac.article_id
JOIN concepts c ON c.concept_id = ac.concept_id
ORDER BY a.title, c.label;
