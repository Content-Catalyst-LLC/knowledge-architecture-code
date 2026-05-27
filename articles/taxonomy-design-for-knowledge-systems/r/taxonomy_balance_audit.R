# Taxonomy depth, breadth, and category-balance audit.

terms <- read.csv("data/taxonomy_terms.csv")
relationships <- read.csv("data/taxonomy_relationships.csv")
assignments <- read.csv("data/term_assignments.csv")

dir.create("outputs", showWarnings = FALSE)

depth_summary <- data.frame(
  term_count = nrow(terms),
  max_depth = max(terms$depth),
  mean_depth = mean(terms$depth),
  median_depth = median(terms$depth)
)

level_summary <- as.data.frame(table(terms$depth))
names(level_summary) <- c("depth", "term_count")

facet_summary <- as.data.frame(table(terms$facet))
names(facet_summary) <- c("facet", "term_count")

relationship_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_summary) <- c("relationship_type", "relationship_count")

assignment_summary <- aggregate(
  assignments$object_id,
  by = list(term_id = assignments$term_id),
  FUN = length
)
names(assignment_summary) <- c("term_id", "assignment_count")

terms_with_assignments <- merge(
  terms,
  assignment_summary,
  by = "term_id",
  all.x = TRUE
)
terms_with_assignments$assignment_count[is.na(terms_with_assignments$assignment_count)] <- 0

write.csv(depth_summary, "outputs/r_taxonomy_depth_summary.csv", row.names = FALSE)
write.csv(level_summary, "outputs/r_taxonomy_level_summary.csv", row.names = FALSE)
write.csv(facet_summary, "outputs/r_taxonomy_facet_summary.csv", row.names = FALSE)
write.csv(relationship_summary, "outputs/r_taxonomy_relationship_summary.csv", row.names = FALSE)
write.csv(terms_with_assignments, "outputs/r_taxonomy_assignment_summary.csv", row.names = FALSE)

print(depth_summary)
print(level_summary)
print(facet_summary)
print(relationship_summary)
