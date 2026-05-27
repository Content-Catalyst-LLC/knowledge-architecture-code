# Taxonomy coherence and category-depth analysis for Foundations of Knowledge Architecture.
# Run from the article folder:
#   Rscript r/taxonomy_coherence_analysis.R

concepts <- read.csv("data/concepts.csv", stringsAsFactors = FALSE)
relationships <- read.csv("data/relationships.csv", stringsAsFactors = FALSE)

if (!dir.exists("outputs")) dir.create("outputs", recursive = TRUE)

domain_summary <- aggregate(
  concept_id ~ domain,
  data = concepts,
  FUN = length
)
names(domain_summary) <- c("domain", "concept_count")
domain_summary <- domain_summary[order(-domain_summary$concept_count), ]

depth_summary <- data.frame(
  concept_count = nrow(concepts),
  relationship_count = nrow(relationships),
  max_depth = max(concepts$depth),
  mean_depth = mean(concepts$depth),
  median_depth = median(concepts$depth),
  core_concepts = sum(concepts$status == "core"),
  applied_concepts = sum(concepts$status == "applied")
)

relationship_summary <- aggregate(
  weight ~ relationship,
  data = relationships,
  FUN = function(x) round(mean(x), 3)
)
names(relationship_summary) <- c("relationship", "mean_weight")
relationship_summary <- relationship_summary[order(-relationship_summary$mean_weight), ]

write.csv(domain_summary, "outputs/r_domain_summary.csv", row.names = FALSE)
write.csv(depth_summary, "outputs/r_depth_summary.csv", row.names = FALSE)
write.csv(relationship_summary, "outputs/r_relationship_summary.csv", row.names = FALSE)

print(domain_summary)
print(depth_summary)
print(relationship_summary)
