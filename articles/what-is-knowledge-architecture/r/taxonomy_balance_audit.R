# What Is Knowledge Architecture?
# Taxonomy balance, depth, and domain audit.

concepts <- read.csv("data/concepts.csv")
relationships <- read.csv("data/relationships.csv")

dir.create("outputs", showWarnings = FALSE)

domain_summary <- aggregate(
  concept_id ~ domain,
  data = concepts,
  FUN = length
)
names(domain_summary) <- c("domain", "concept_count")

depth_summary <- data.frame(
  total_concepts = nrow(concepts),
  total_relationships = nrow(relationships),
  max_depth = max(concepts$depth),
  mean_depth = mean(concepts$depth),
  median_depth = median(concepts$depth)
)

relationship_summary <- aggregate(
  source ~ relationship_type,
  data = relationships,
  FUN = length
)
names(relationship_summary) <- c("relationship_type", "count")

write.csv(domain_summary, "outputs/r_domain_summary.csv", row.names = FALSE)
write.csv(depth_summary, "outputs/r_depth_summary.csv", row.names = FALSE)
write.csv(relationship_summary, "outputs/r_relationship_type_summary.csv", row.names = FALSE)

print(domain_summary)
print(depth_summary)
print(relationship_summary)
