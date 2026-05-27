# Institutional Knowledge System Diagnostics
# Base R workflow for metadata coverage, traceability, access levels, and stewardship review.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "research_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "object_relationships.csv"), stringsAsFactors = FALSE)
governance <- read.csv(file.path(data_dir, "governance_records.csv"), stringsAsFactors = FALSE)
stewardship <- read.csv(file.path(data_dir, "stewardship_checks.csv"), stringsAsFactors = FALSE)

objects$has_metadata <- tolower(objects$has_metadata) == "true"

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

access_level_summary <- as.data.frame(table(objects$access_level))
names(access_level_summary) <- c("access_level", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

relationship_ids <- c(relationships$source_object_id, relationships$target_object_id)

degree_table <- data.frame(
  object_id = objects$object_id,
  title = objects$title,
  object_type = objects$object_type,
  access_level = objects$access_level,
  has_metadata = objects$has_metadata,
  degree = sapply(objects$object_id, function(x) sum(relationship_ids == x))
)

degree_table$is_orphan <- degree_table$degree == 0

governance_count <- sapply(objects$object_id, function(x) sum(governance$object_id == x))
degree_table$governance_record_count <- governance_count

degree_table$needs_stewardship_review <- !degree_table$has_metadata |
  degree_table$is_orphan |
  degree_table$object_id %in% governance$object_id[governance$review_status == "needs_review"]

governance_summary <- as.data.frame(table(governance$governance_type, governance$review_status))
names(governance_summary) <- c("governance_type", "review_status", "count")

stewardship_summary <- as.data.frame(table(stewardship$layer, stewardship$severity))
names(stewardship_summary) <- c("layer", "severity", "count")

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  metadata_coverage = mean(objects$has_metadata),
  relationship_traceability = mean(relationships$provenance_note != ""),
  orphan_count = sum(degree_table$is_orphan),
  stewardship_review_count = sum(degree_table$needs_stewardship_review)
)

write.csv(object_type_summary, file.path(outputs_dir, "r_institutional_object_type_summary.csv"), row.names = FALSE)
write.csv(access_level_summary, file.path(outputs_dir, "r_institutional_access_level_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_institutional_relationship_type_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_institutional_degree_table.csv"), row.names = FALSE)
write.csv(governance_summary, file.path(outputs_dir, "r_governance_summary.csv"), row.names = FALSE)
write.csv(stewardship_summary, file.path(outputs_dir, "r_stewardship_summary.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_institutional_coverage_summary.csv"), row.names = FALSE)

print(object_type_summary)
print(access_level_summary)
print(coverage_summary)
