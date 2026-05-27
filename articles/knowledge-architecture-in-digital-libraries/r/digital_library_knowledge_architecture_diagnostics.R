script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(getwd(), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "digital_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "digital_library_relationships.csv"), stringsAsFactors = FALSE)

objects$has_metadata <- tolower(objects$has_metadata) == "true"
objects$has_subject <- tolower(objects$has_subject) == "true"
objects$has_rights <- tolower(objects$has_rights) == "true"
objects$has_preservation <- tolower(objects$has_preservation) == "true"

relationship_ids <- c(relationships$source_object_id, relationships$target_object_id)

degree_table <- data.frame(
  object_id = objects$object_id,
  title = objects$title,
  object_type = objects$object_type,
  has_metadata = objects$has_metadata,
  has_subject = objects$has_subject,
  has_rights = objects$has_rights,
  has_preservation = objects$has_preservation,
  status = objects$status,
  degree = sapply(objects$object_id, function(x) sum(relationship_ids == x))
)

degree_table$is_orphan <- degree_table$degree == 0
degree_table$needs_review <- !degree_table$has_metadata |
  !degree_table$has_rights |
  degree_table$status == "review_needed" |
  degree_table$is_orphan

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  metadata_coverage = mean(objects$has_metadata),
  subject_coverage = mean(objects$has_subject),
  rights_coverage = mean(objects$has_rights),
  preservation_coverage = mean(objects$has_preservation),
  relationship_traceability = mean(relationships$provenance_note != ""),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review)
)

write.csv(object_type_summary, file.path(outputs_dir, "r_digital_library_object_type_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_digital_library_relationship_type_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_digital_library_degree_table.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_digital_library_coverage_summary.csv"), row.names = FALSE)

print(coverage_summary)
