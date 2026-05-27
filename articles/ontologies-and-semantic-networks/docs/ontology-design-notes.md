# Ontology Design Notes

## Minimal Ontology Scope

This article folder models a small Knowledge Architecture semantic domain.

Primary classes:

- Domain
- Article
- Concept
- Standard
- Method
- Dataset
- RepositoryFolder
- EvidenceSource
- RelationshipType

Core relationships:

- `includes`
- `isPartOfSeries`
- `supports`
- `requires`
- `structures`
- `models`
- `canEncode`
- `canRepresent`
- `isRelatedTo`
- `citesSource`
- `usesMethod`

## Design Principle

The ontology separates publication objects from conceptual objects. An article is not the same as a concept. A dataset is not the same as evidence unless its evidence role is defined. A relationship is not meaningful unless its predicate is named and documented.
