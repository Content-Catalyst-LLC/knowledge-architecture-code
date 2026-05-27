# Taxonomy diagnostics and category-depth workflow.

concepts <- read.csv("data/concepts.csv")
relationships <- read.csv("data/relationships.csv")

dir.create("outputs", showWarnings = FALSE)

summary <- data.frame(
  concept_count = nrow(concepts),
  relationship_count = nrow(relationships),
  max_depth = max(concepts$depth),
  mean_depth = mean(concepts$depth)
)

write.csv(summary, "outputs/taxonomy_summary.csv", row.names = FALSE)
print(summary)
