# Sustainability Knowledge Architecture Diagnostics
# Base R workflow for object, scale, justice, uncertainty, and relationship coverage.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "sustainability_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "sustainability_relationships.csv"), stringsAsFactors = FALSE)
systems <- read.csv(file.path(data_dir, "systems.csv"), stringsAsFactors = FALSE)
concepts <- read.csv(file.path(data_dir, "concepts.csv"), stringsAsFactors = FALSE)
governance <- read.csv(file.path(data_dir, "governance_checks.csv"), stringsAsFactors = FALSE)

objects$has_metadata <- tolower(objects$has_metadata) == "true"
objects$has_justice_context <- tolower(objects$has_justice_context) == "true"
objects$has_uncertainty_context <- tolower(objects$has_uncertainty_context) == "true"

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

scale_summary <- as.data.frame(table(objects$scale))
names(scale_summary) <- c("scale", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

system_type_summary <- as.data.frame(table(systems$system_type))
names(system_type_summary) <- c("system_type", "count")

relationship_ids <- c(relationships$source_object_id, relationships$target_object_id)

degree_table <- data.frame(
  object_id = objects$object_id,
  title = objects$title,
  object_type = objects$object_type,
  has_metadata = objects$has_metadata,
  scale = objects$scale,
  has_justice_context = objects$has_justice_context,
  has_uncertainty_context = objects$has_uncertainty_context,
  status = objects$status,
  degree = sapply(objects$object_id, function(x) sum(relationship_ids == x))
)

degree_table$is_orphan <- degree_table$degree == 0
degree_table$needs_review <- !degree_table$has_metadata |
  degree_table$status == "review_needed" |
  degree_table$is_orphan

governance_summary <- as.data.frame(table(governance$layer, governance$severity))
names(governance_summary) <- c("layer", "severity", "count")

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  system_count = nrow(systems),
  concept_count = nrow(concepts),
  metadata_coverage = mean(objects$has_metadata),
  justice_context_coverage = mean(objects$has_justice_context),
  uncertainty_context_coverage = mean(objects$has_uncertainty_context),
  relationship_traceability = mean(relationships$provenance_note != ""),
  underspecified_relationship_risk = mean(relationships$relationship_type %in% c("related", "sameAs", "")),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review),
  scale_count = length(unique(objects$scale))
)

write.csv(object_type_summary, file.path(outputs_dir, "r_sustainability_object_type_summary.csv"), row.names = FALSE)
write.csv(scale_summary, file.path(outputs_dir, "r_sustainability_scale_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_sustainability_relationship_type_summary.csv"), row.names = FALSE)
write.csv(system_type_summary, file.path(outputs_dir, "r_sustainability_system_type_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_sustainability_degree_table.csv"), row.names = FALSE)
write.csv(governance_summary, file.path(outputs_dir, "r_sustainability_governance_summary.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_sustainability_coverage_summary.csv"), row.names = FALSE)

print(object_type_summary)
print(scale_summary)
print(coverage_summary)
