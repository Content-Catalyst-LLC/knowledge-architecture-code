# Semantic-network diagnostics for Ontologies and Semantic Networks.
# Uses base R only for portability.

nodes <- read.csv("data/nodes.csv")
edges <- read.csv("data/edges.csv")
classes <- read.csv("data/ontology_classes.csv")
properties <- read.csv("data/properties.csv")
triples <- read.csv("data/triples.csv")

dir.create("outputs", showWarnings = FALSE)

relationship_summary <- as.data.frame(table(edges$relationship))
names(relationship_summary) <- c("relationship", "count")

node_type_summary <- as.data.frame(table(nodes$node_type))
names(node_type_summary) <- c("node_type", "count")

degree <- sapply(nodes$node_id, function(x) {
  sum(edges$source == x) + sum(edges$target == x)
})

in_degree <- sapply(nodes$node_id, function(x) {
  sum(edges$target == x)
})

out_degree <- sapply(nodes$node_id, function(x) {
  sum(edges$source == x)
})

degree_table <- data.frame(
  node_id = nodes$node_id,
  label = nodes$label,
  node_type = nodes$node_type,
  degree = degree,
  in_degree = in_degree,
  out_degree = out_degree,
  is_orphan = degree == 0
)

quality_summary <- data.frame(
  metric = c(
    "node_count",
    "edge_count",
    "class_count",
    "property_count",
    "triple_count",
    "orphan_count",
    "relationship_type_count"
  ),
  value = c(
    nrow(nodes),
    nrow(edges),
    nrow(classes),
    nrow(properties),
    nrow(triples),
    sum(degree == 0),
    length(unique(edges$relationship))
  )
)

write.csv(relationship_summary, "outputs/r_semantic_relationship_summary.csv", row.names = FALSE)
write.csv(node_type_summary, "outputs/r_semantic_node_type_summary.csv", row.names = FALSE)
write.csv(degree_table, "outputs/r_semantic_node_degree_table.csv", row.names = FALSE)
write.csv(quality_summary, "outputs/r_semantic_quality_summary.csv", row.names = FALSE)

print(relationship_summary)
print(node_type_summary)
print(degree_table)
print(quality_summary)
