# Digital Knowledge Platform Diagnostics
# Base R workflow for platform coverage, relationship traceability, and governance summaries.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "platform_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "platform_relationships.csv"), stringsAsFactors = FALSE)
governance <- read.csv(file.path(data_dir, "governance_checks.csv"), stringsAsFactors = FALSE)
repo_alignment <- read.csv(file.path(data_dir, "repository_alignment.csv"), stringsAsFactors = FALSE)

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

relationship_ids <- c(relationships$source_object_id, relationships$target_object_id)

degree_table <- data.frame(
  object_id = objects$object_id,
  title = objects$title,
  object_type = objects$object_type,
  has_metadata = tolower(objects$has_metadata) == "true",
  degree = sapply(objects$object_id, function(x) sum(relationship_ids == x))
)

degree_table$is_orphan <- degree_table$degree == 0

governance_summary <- as.data.frame(table(governance$layer, governance$severity))
names(governance_summary) <- c("layer", "severity", "count")

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  metadata_coverage = mean(tolower(objects$has_metadata) == "true"),
  relationship_traceability = mean(relationships$provenance_note != ""),
  repository_alignment = mean(tolower(repo_alignment$folder_exists_in_scaffold) == "true"),
  orphan_count = sum(degree_table$is_orphan)
)

write.csv(object_type_summary, file.path(outputs_dir, "r_platform_object_type_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_platform_relationship_type_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_platform_degree_table.csv"), row.names = FALSE)
write.csv(governance_summary, file.path(outputs_dir, "r_governance_summary.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_platform_coverage_summary.csv"), row.names = FALSE)

print(object_type_summary)
print(relationship_type_summary)
print(coverage_summary)
