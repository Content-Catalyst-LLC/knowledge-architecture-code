# AI Knowledge Organization Diagnostics
# Base R workflow for metadata, retrieval, provenance, review, and correction diagnostics.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "ai_ko_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "ai_ko_relationships.csv"), stringsAsFactors = FALSE)
retrieval_records <- read.csv(file.path(data_dir, "retrieval_records.csv"), stringsAsFactors = FALSE)
ai_outputs <- read.csv(file.path(data_dir, "ai_outputs.csv"), stringsAsFactors = FALSE)
human_reviews <- read.csv(file.path(data_dir, "human_review_records.csv"), stringsAsFactors = FALSE)
source_hierarchy <- read.csv(file.path(data_dir, "source_hierarchy_rules.csv"), stringsAsFactors = FALSE)

objects$has_metadata <- tolower(objects$has_metadata) == "true"
objects$has_provenance <- tolower(objects$has_provenance) == "true"
objects$has_review_context <- tolower(objects$has_review_context) == "true"
retrieval_records$reviewed <- tolower(retrieval_records$reviewed) == "true"

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

ai_output_review_summary <- as.data.frame(table(ai_outputs$review_status))
names(ai_output_review_summary) <- c("review_status", "count")

human_review_summary <- as.data.frame(table(human_reviews$review_status))
names(human_review_summary) <- c("review_status", "count")

source_rank_summary <- as.data.frame(table(source_hierarchy$authority_rank))
names(source_rank_summary) <- c("authority_rank", "count")

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

retrieval_diagnostics <- data.frame(
  retrieval_id = retrieval_records$retrieval_id,
  index_id = retrieval_records$index_id,
  retrieved_object_id = retrieval_records$retrieved_object_id,
  rank_position = retrieval_records$rank_position,
  reviewed = retrieval_records$reviewed,
  needs_review = !retrieval_records$reviewed
)

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  retrieval_record_count = nrow(retrieval_records),
  ai_output_count = nrow(ai_outputs),
  metadata_coverage = mean(objects$has_metadata),
  provenance_coverage = mean(objects$has_provenance),
  review_context_coverage = mean(objects$has_review_context),
  relationship_traceability = mean(relationships$provenance_note != ""),
  underspecified_relationship_risk = mean(relationships$relationship_type %in% c("related", "sameAs", "")),
  retrieval_review_coverage = mean(retrieval_records$reviewed),
  grounding_link_count = sum(relationships$relationship_type %in% c("groundedBy", "retrieves", "describedBy", "groundsOutput")),
  review_link_count = sum(relationships$relationship_type == "reviews"),
  revision_link_count = sum(relationships$relationship_type %in% c("revises", "updates")),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review)
)

write.csv(object_type_summary, file.path(outputs_dir, "r_ai_ko_object_type_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_ai_ko_relationship_type_summary.csv"), row.names = FALSE)
write.csv(ai_output_review_summary, file.path(outputs_dir, "r_ai_ko_ai_output_review_summary.csv"), row.names = FALSE)
write.csv(human_review_summary, file.path(outputs_dir, "r_ai_ko_human_review_summary.csv"), row.names = FALSE)
write.csv(source_rank_summary, file.path(outputs_dir, "r_ai_ko_source_rank_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_ai_ko_degree_table.csv"), row.names = FALSE)
write.csv(retrieval_diagnostics, file.path(outputs_dir, "r_ai_ko_retrieval_diagnostics.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_ai_ko_coverage_summary.csv"), row.names = FALSE)

print(object_type_summary)
print(relationship_type_summary)
print(coverage_summary)
