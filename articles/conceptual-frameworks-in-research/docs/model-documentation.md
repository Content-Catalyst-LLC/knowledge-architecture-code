# Model Documentation

This folder models a conceptual framework as a structured knowledge system.

## Data Files

- `framework_concepts.csv` — concepts, roles, domains, evidence status, and definitions
- `framework_relationships.csv` — source concepts, target concepts, relationship types, and assumption notes
- `evidence_sources.csv` — evidence records used to support framework concepts
- `concept_evidence.csv` — many-to-many links between concepts and evidence sources
- `framework_versions.csv` — version records for framework maintenance

## Analytical Questions

- Which concepts are most central?
- Which concepts are unsupported or provisional?
- Which relationship types dominate the framework?
- Does the framework have balanced conceptual roles?
- Are evidence sources linked to the concepts they support?
- Are framework assumptions documented enough for revision?

## Outputs

Scripts generate CSV and Markdown summaries in `outputs/`.
