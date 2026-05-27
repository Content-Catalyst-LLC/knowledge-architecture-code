# Knowledge Mapping and Conceptual Models
# Conceptual model coverage diagnostics.

concepts <- read.csv("data/concepts.csv")
relationships <- read.csv("data/relationships.csv")

dir.create("outputs", showWarnings = FALSE)

concept_type_summary <- as.data.frame(table(concepts$concept_type))
names(concept_type_summary) <- c("concept_type", "count")

domain_summary <- as.data.frame(table(concepts$domain))
names(domain_summary) <- c("domain", "count")

relationship_summary <- as.data.frame(table(relationships$relationship))
names(relationship_summary) <- c("relationship", "count")

evidence_summary <- as.data.frame(table(relationships$evidence_status))
names(evidence_summary) <- c("evidence_status", "count")

degree_table <- data.frame(
  concept_id = concepts$concept_id,
  label = concepts$label,
  concept_type = concepts$concept_type,
  domain = concepts$domain,
  degree = sapply(concepts$concept_id, function(x) {
    sum(relationships$source == x) + sum(relationships$target == x)
  })
)

degree_table$is_orphan <- degree_table$degree == 0

coverage_summary <- data.frame(
  concept_count = nrow(concepts),
  relationship_count = nrow(relationships),
  documented_relationships = sum(relationships$evidence_status == "documented"),
  provisional_relationships = sum(relationships$evidence_status == "provisional"),
  evidence_coverage = mean(relationships$evidence_status == "documented"),
  orphan_count = sum(degree_table$is_orphan)
)

write.csv(concept_type_summary, "outputs/concept_type_summary.csv", row.names = FALSE)
write.csv(domain_summary, "outputs/domain_summary.csv", row.names = FALSE)
write.csv(relationship_summary, "outputs/model_relationship_summary.csv", row.names = FALSE)
write.csv(evidence_summary, "outputs/evidence_status_summary_r.csv", row.names = FALSE)
write.csv(degree_table, "outputs/model_degree_table.csv", row.names = FALSE)
write.csv(coverage_summary, "outputs/model_coverage_summary.csv", row.names = FALSE)

print(concept_type_summary)
print(domain_summary)
print(relationship_summary)
print(coverage_summary)
