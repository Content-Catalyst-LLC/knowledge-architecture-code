# Analytical Model Coverage Audit
# Uses base R only.

elements <- read.csv("data/model_elements.csv")
relationships <- read.csv("data/model_relationships.csv")

dir.create("outputs", showWarnings = FALSE)

role_summary <- as.data.frame(table(elements$role))
names(role_summary) <- c("role", "element_count")

status_summary <- as.data.frame(table(elements$evidence_status))
names(status_summary) <- c("evidence_status", "element_count")

relationship_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_summary) <- c("relationship_type", "relationship_count")

coverage_summary <- data.frame(
  total_elements = nrow(elements),
  total_relationships = nrow(relationships),
  documented_relationships = sum(tolower(relationships$documented) == "true"),
  documented_relationship_share = mean(tolower(relationships$documented) == "true"),
  documented_elements = sum(elements$evidence_status == "documented"),
  provisional_elements = sum(elements$evidence_status == "provisional"),
  underdeveloped_elements = sum(elements$evidence_status == "underdeveloped")
)

write.csv(role_summary, "outputs/model_role_summary.csv", row.names = FALSE)
write.csv(status_summary, "outputs/model_evidence_status_summary.csv", row.names = FALSE)
write.csv(relationship_summary, "outputs/model_relationship_summary.csv", row.names = FALSE)
write.csv(coverage_summary, "outputs/model_coverage_summary.csv", row.names = FALSE)

print(role_summary)
print(status_summary)
print(coverage_summary)
