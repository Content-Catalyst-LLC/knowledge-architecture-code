-- Diagnostic examples after loading CSV data into the schema.

-- Domain balance
SELECT domain, COUNT(*) AS concept_count
FROM concepts
GROUP BY domain
ORDER BY concept_count DESC, domain;

-- Relationship type balance
SELECT relationship, COUNT(*) AS relationship_count, ROUND(AVG(weight), 3) AS avg_weight
FROM relationships
GROUP BY relationship
ORDER BY relationship_count DESC, relationship;

-- Taxonomy-depth profile
SELECT depth, COUNT(*) AS concept_count
FROM concepts
GROUP BY depth
ORDER BY depth;
