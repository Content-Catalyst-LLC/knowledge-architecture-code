# Framework coverage and concept-balance audit.
# Uses base R only.

root <- normalizePath(file.path(getwd()), mustWork = FALSE)

if (!file.exists("data/framework_concepts.csv")) {
  stop("Run from the article folder: articles/conceptual-frameworks-in-research")
}

concepts <- read.csv("data/framework_concepts.csv", stringsAsFactors = FALSE)
relationships <- read.csv("data/framework_relationships.csv", stringsAsFactors = FALSE)
concept_evidence <- read.csv("data/concept_evidence.csv", stringsAsFactors = FALSE)

dir.create("outputs", showWarnings = FALSE)

role_summary <- as.data.frame(table(concepts$role))
names(role_summary) <- c("role", "concept_count")

evidence_status_summary <- as.data.frame(table(concepts$evidence_status))
names(evidence_status_summary) <- c("evidence_status", "concept_count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

evidence_counts <- aggregate(
  evidence_id ~ concept_id,
  data = concept_evidence,
  FUN = length
)
names(evidence_counts) <- c("concept_id", "evidence_links")

concept_audit <- merge(concepts, evidence_counts, by = "concept_id", all.x = TRUE)
concept_audit$evidence_links[is.na(concept_audit$evidence_links)] <- 0

coverage_summary <- data.frame(
  total_concepts = nrow(concepts),
  supported_concepts = sum(concepts$evidence_status == "supported"),
  provisional_concepts = sum(concepts$evidence_status != "supported"),
  relationship_count = nrow(relationships),
  evidence_link_count = nrow(concept_evidence),
  evidence_coverage_rate = mean(concept_audit$evidence_links > 0)
)

write.csv(role_summary, "outputs/framework_role_summary.csv", row.names = FALSE)
write.csv(evidence_status_summary, "outputs/framework_evidence_status_summary.csv", row.names = FALSE)
write.csv(relationship_type_summary, "outputs/framework_relationship_type_summary_r.csv", row.names = FALSE)
write.csv(concept_audit, "outputs/framework_concept_evidence_audit.csv", row.names = FALSE)
write.csv(coverage_summary, "outputs/framework_coverage_summary.csv", row.names = FALSE)

print(role_summary)
print(evidence_status_summary)
print(coverage_summary)
