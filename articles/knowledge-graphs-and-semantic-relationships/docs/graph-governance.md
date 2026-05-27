# Graph Governance Notes

Knowledge graphs require governance because nodes, relationship types, edge assertions, and provenance records change over time.

## Review Questions

- Are node types used consistently?
- Are relationship types specific enough to preserve meaning?
- Are edges traceable to provenance records?
- Are provisional relationships clearly marked?
- Are deprecated concepts preserved with context rather than silently deleted?
- Are interdisciplinary concepts linked without being collapsed into false equivalence?
- Are graph outputs reproducible from the repository data?

## Recommended Workflow

1. Add or revise node records.
2. Add relationship-type definitions before adding new edge classes.
3. Add edge assertions with provenance.
4. Run diagnostics.
5. Review warnings and generated outputs.
6. Commit changes with a clear revision message.
