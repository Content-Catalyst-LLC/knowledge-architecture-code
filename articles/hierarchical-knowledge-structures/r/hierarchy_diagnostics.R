# hierarchy_diagnostics.R
# Depth, breadth, branching, and leaf-rate diagnostics for hierarchical knowledge structures.

nodes <- read.csv("data/hierarchy_nodes.csv", stringsAsFactors = FALSE)
edges <- read.csv("data/hierarchy_edges.csv", stringsAsFactors = FALSE)

dir.create("outputs", showWarnings = FALSE)

parents <- split(edges$parent_id, edges$child_id)
children <- split(edges$child_id, edges$parent_id)

root_ids <- setdiff(nodes$node_id, edges$child_id)

depths <- data.frame(node_id = character(), depth = integer(), stringsAsFactors = FALSE)

queue <- data.frame(node_id = root_ids, depth = rep(0, length(root_ids)), stringsAsFactors = FALSE)

while (nrow(queue) > 0) {
  current <- queue[1, ]
  queue <- queue[-1, , drop = FALSE]

  if (!(current$node_id %in% depths$node_id)) {
    depths <- rbind(depths, current)

    node_children <- children[[current$node_id]]
    if (!is.null(node_children)) {
      queue <- rbind(
        queue,
        data.frame(
          node_id = node_children,
          depth = rep(current$depth + 1, length(node_children)),
          stringsAsFactors = FALSE
        )
      )
    }
  }
}

child_counts <- aggregate(child_id ~ parent_id, data = edges, FUN = length)
names(child_counts) <- c("node_id", "child_count")

parent_counts <- aggregate(parent_id ~ child_id, data = edges, FUN = length)
names(parent_counts) <- c("node_id", "parent_count")

diagnostics <- merge(nodes, depths, by = "node_id", all.x = TRUE)
diagnostics <- merge(diagnostics, child_counts, by = "node_id", all.x = TRUE)
diagnostics <- merge(diagnostics, parent_counts, by = "node_id", all.x = TRUE)

diagnostics$child_count[is.na(diagnostics$child_count)] <- 0
diagnostics$parent_count[is.na(diagnostics$parent_count)] <- 0
diagnostics$is_root <- diagnostics$parent_count == 0
diagnostics$is_leaf <- diagnostics$child_count == 0
diagnostics$is_polyhierarchical <- diagnostics$parent_count > 1

depth_summary <- data.frame(
  node_count = nrow(nodes),
  edge_count = nrow(edges),
  root_count = length(root_ids),
  max_depth = max(diagnostics$depth, na.rm = TRUE),
  mean_depth = mean(diagnostics$depth, na.rm = TRUE),
  median_depth = median(diagnostics$depth, na.rm = TRUE),
  leaf_count = sum(diagnostics$is_leaf),
  leaf_rate = mean(diagnostics$is_leaf),
  mean_child_count = mean(diagnostics$child_count)
)

breadth_by_level <- aggregate(node_id ~ depth, data = diagnostics, FUN = length)
names(breadth_by_level) <- c("depth", "node_count")

write.csv(diagnostics, "outputs/r_hierarchy_node_diagnostics.csv", row.names = FALSE)
write.csv(depth_summary, "outputs/r_hierarchy_depth_summary.csv", row.names = FALSE)
write.csv(breadth_by_level, "outputs/r_hierarchy_breadth_by_level.csv", row.names = FALSE)

print(depth_summary)
print(breadth_by_level)
