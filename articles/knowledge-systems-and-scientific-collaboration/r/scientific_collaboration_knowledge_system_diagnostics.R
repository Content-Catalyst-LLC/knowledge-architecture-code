# Scientific Collaboration Knowledge System Diagnostics
# Base R workflow for collaboration, metadata, provenance, reproducibility, and governance diagnostics.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "scientific_collaboration_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "scientific_collaboration_relationships.csv"), stringsAsFactors = FALSE)
contributors <- read.csv(file.path(data_dir, "contributors.csv"), stringsAsFactors = FALSE)
datasets <- read.csv(file.path(data_dir, "datasets.csv"), stringsAsFactors = FALSE)
software <- read.csv(file.path(data_dir, "software_artifacts.csv"), stringsAsFactors = FALSE)

objects$has_metadata <- tolower(objects$has_metadata) == "true"
objects$has_provenance <- tolower(objects$has_provenance) == "true"
objects$has_review_context <- tolower(objects$has_review_context) == "true"

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

contributor_role_summary <- as.data.frame(table(contributors$role))
names(contributor_role_summary) <- c("role", "count")

institution_summary <- as.data.frame(table(contributors$institution))
names(institution_summary) <- c("institution", "count")

dataset_status_summary <- as.data.frame(table(datasets$review_status))
names(dataset_status_summary) <- c("review_status", "count")

software_status_summary <- as.data.frame(table(software$review_status))
names(software_status_summary) <- c("review_status", "count")

relationship_ids <- c(relationships$source_object_id, relationships$target_object_id)

degree_table <- data.frame(
  object_id = objects$object_id,
  title = objects$title,
  object_type = objects$object_type,
  has_metadata = objects$has_metadata,
  has_provenance = objects$has_provenance,
  has_review_context = objects$has_review_context,
  status = objects$status,
  degree = sapply(objects$object_id, function(x) sum(relationship_ids == x))
)

degree_table$is_orphan <- degree_table$degree == 0
degree_table$needs_review <- !degree_table$has_metadata |
  !degree_table$has_provenance |
  !degree_table$has_review_context |
  degree_table$status == "review_needed" |
  degree_table$is_orphan

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  contributor_count = nrow(contributors),
  contributor_role_count = length(unique(contributors$role)),
  institution_count = length(unique(contributors$institution)),
  dataset_count = nrow(datasets),
  software_artifact_count = nrow(software),
  metadata_coverage = mean(objects$has_metadata),
  provenance_coverage = mean(objects$has_provenance),
  review_context_coverage = mean(objects$has_review_context),
  relationship_traceability = mean(relationships$provenance_note != ""),
  underspecified_relationship_risk = mean(relationships$relationship_type %in% c("related", "sameAs", "")),
  reproducibility_link_count = sum(relationships$relationship_type %in% c("describedBy", "analyzedBy", "dependsOn", "generates", "producesData", "supportsClaimIn")),
  review_link_count = sum(relationships$relationship_type %in% c("reviews", "tests")),
  revision_link_count = sum(relationships$relationship_type %in% c("revises", "updates")),
  ethics_link_count = sum(relationships$relationship_type == "governs"),
  repository_link_count = sum(relationships$relationship_type == "stores"),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review)
)

write.csv(object_type_summary, file.path(outputs_dir, "r_scientific_collaboration_object_type_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_scientific_collaboration_relationship_type_summary.csv"), row.names = FALSE)
write.csv(contributor_role_summary, file.path(outputs_dir, "r_scientific_collaboration_contributor_role_summary.csv"), row.names = FALSE)
write.csv(institution_summary, file.path(outputs_dir, "r_scientific_collaboration_institution_summary.csv"), row.names = FALSE)
write.csv(dataset_status_summary, file.path(outputs_dir, "r_scientific_collaboration_dataset_status_summary.csv"), row.names = FALSE)
write.csv(software_status_summary, file.path(outputs_dir, "r_scientific_collaboration_software_status_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_scientific_collaboration_degree_table.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_scientific_collaboration_coverage_summary.csv"), row.names = FALSE)

print(object_type_summary)
print(contributor_role_summary)
print(coverage_summary)
