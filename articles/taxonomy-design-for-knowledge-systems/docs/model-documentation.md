# Model Documentation

The examples in this article folder use a small synthetic taxonomy for knowledge architecture.

## Data files

- `taxonomy_terms.csv` — preferred taxonomy terms, parent relationships, depth, scope notes, and status
- `taxonomy_relationships.csv` — broader, narrower, related, and equivalent term relationships
- `knowledge_objects.csv` — example articles or repository objects assigned to taxonomy terms
- `term_assignments.csv` — many-to-many assignments between knowledge objects and taxonomy terms

## Diagnostic outputs

Scripts generate outputs such as:

- node diagnostics
- depth summaries
- parent-child counts
- orphan-node reports
- relationship-type summaries
- taxonomy quality checks

## Interpretation

Metrics are signals, not conclusions. A deep taxonomy may be useful or burdensome depending on the domain. A broad category may be necessary or overloaded. Orphan nodes may represent weak integration or deliberate future expansion. Human interpretation and governance remain essential.
