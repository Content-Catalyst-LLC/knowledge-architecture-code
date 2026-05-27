# Model Documentation

Hierarchical knowledge structures can be represented in several ways:

## Parent-child table

A simple edge table with `parent_id` and `child_id`.

## Closure table

A table that stores every ancestor-descendant relationship, making it easier to query all descendants of a node or all ancestors of an item.

## Tree

A hierarchy where each non-root node has one parent.

## Directed acyclic graph

A directed graph with no cycles. DAGs can support polyhierarchy, where a node may have more than one parent.

## General graph

A graph that may include hierarchical, associative, causal, evidentiary, prerequisite, and navigational relationships.

For article maps and public navigation, simpler tree-like structures are often clearer. For interdisciplinary knowledge systems, DAGs and knowledge graphs are often more realistic.
