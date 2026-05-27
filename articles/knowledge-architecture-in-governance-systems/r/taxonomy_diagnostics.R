# Synthetic taxonomy diagnostics for a Knowledge Architecture article.

concepts <- read.csv("data/synthetic/concepts.csv")
relationships <- read.csv("data/synthetic/relationships.csv")

dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

depth_summary <- data.frame(
  max_depth = max(concepts$depth),
  mean_depth = mean(concepts$depth),
  concept_count = nrow(concepts),
  relationship_count = nrow(relationships)
)

write.csv(depth_summary, "outputs/tables/taxonomy_depth_summary.csv", row.names = FALSE)

print(depth_summary)
