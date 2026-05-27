# Knowledge graph diagnostics for node types, relationship types, degree, and provenance coverage.

nodes <- read.csv("data/nodes.csv")
edges <- read.csv("data/edges.csv")
relationship_types <- read.csv("data/relationship_types.csv")
evidence_sources <- read.csv("data/evidence_sources.csv")

dir.create("outputs", showWarnings = FALSE)

node_type_summary <- as.data.frame(table(nodes$node_type))
names(node_type_summary) <- c("node_type", "count")

relationship_summary <- as.data.frame(table(edges$relationship_type_id))
names(relationship_summary) <- c("relationship_type_id", "edge_count")

degree_table <- data.frame(
  node_id = nodes$node_id,
  label = nodes$label,
  node_type = nodes$node_type,
  degree = sapply(nodes$node_id, function(x) {
    sum(edges$source_node_id == x) + sum(edges$target_node_id == x)
  }),
  in_degree = sapply(nodes$node_id, function(x) sum(edges$target_node_id == x)),
  out_degree = sapply(nodes$node_id, function(x) sum(edges$source_node_id == x))
)

degree_table$is_orphan <- degree_table$degree == 0

provenance_summary <- data.frame(
  edge_count = nrow(edges),
  edges_with_provenance = sum(edges$provenance_id != ""),
  provenance_records = nrow(evidence_sources),
  provenance_coverage = mean(edges$provenance_id != "")
)

write.csv(node_type_summary, "outputs/r_node_type_summary.csv", row.names = FALSE)
write.csv(relationship_summary, "outputs/r_relationship_summary.csv", row.names = FALSE)
write.csv(degree_table, "outputs/r_degree_table.csv", row.names = FALSE)
write.csv(provenance_summary, "outputs/r_provenance_summary.csv", row.names = FALSE)

print(node_type_summary)
print(relationship_summary)
print(degree_table)
print(provenance_summary)
