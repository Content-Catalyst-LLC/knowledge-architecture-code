# Future Knowledge Platform Diagnostics
# Base R workflow for platform coverage, trust readiness, reuse readiness, and governance diagnostics.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "future_platform_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "future_platform_relationships.csv"), stringsAsFactors = FALSE)
repositories <- read.csv(file.path(data_dir, "repositories.csv"), stringsAsFactors = FALSE)
ai_records <- read.csv(file.path(data_dir, "ai_records.csv"), stringsAsFactors = FALSE)
accessibility <- read.csv(file.path(data_dir, "accessibility_records.csv"), stringsAsFactors = FALSE)
resilience <- read.csv(file.path(data_dir, "resilience_records.csv"), stringsAsFactors = FALSE)

objects$has_metadata <- tolower(objects$has_metadata) == "true"
objects$has_provenance <- tolower(objects$has_provenance) == "true"
objects$has_reuse_context <- tolower(objects$has_reuse_context) == "true"
objects$has_review_context <- tolower(objects$has_review_context) == "true"

accessibility$has_alt_text <- tolower(accessibility$has_alt_text) == "true"
accessibility$has_captions <- tolower(accessibility$has_captions) == "true"
accessibility$has_transcript <- tolower(accessibility$has_transcript) == "true"

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

repository_status_summary <- as.data.frame(table(repositories$review_status))
names(repository_status_summary) <- c("review_status", "count")

ai_review_summary <- as.data.frame(table(ai_records$human_review_status))
names(ai_review_summary) <- c("human_review_status", "count")

resilience_status_summary <- as.data.frame(table(resilience$status))
names(resilience_status_summary) <- c("status", "count")

relationship_ids <- c(relationships$source_object_id, relationships$target_object_id)

degree_table <- data.frame(
  object_id = objects$object_id,
  title = objects$title,
  object_type = objects$object_type,
  has_metadata = objects$has_metadata,
  has_provenance = objects$has_provenance,
  has_reuse_context = objects$has_reuse_context,
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

accessibility$accessibility_completeness <- rowMeans(
  accessibility[, c("has_alt_text", "has_captions", "has_transcript")]
)

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  repository_count = nrow(repositories),
  ai_record_count = nrow(ai_records),
  metadata_coverage = mean(objects$has_metadata),
  provenance_coverage = mean(objects$has_provenance),
  reuse_context_coverage = mean(objects$has_reuse_context),
  review_context_coverage = mean(objects$has_review_context),
  relationship_traceability = mean(relationships$provenance_note != ""),
  underspecified_relationship_risk = mean(relationships$relationship_type %in% c("related", "sameAs", "")),
  accessibility_mean_completeness = mean(accessibility$accessibility_completeness),
  ai_grounding_link_count = sum(relationships$relationship_type %in% c("retrieves", "groundedBy")),
  repository_link_count = sum(relationships$relationship_type == "supportedByRepository"),
  governance_link_count = sum(relationships$relationship_type %in% c("requiresReview", "governsRankingOf")),
  revision_link_count = sum(relationships$relationship_type == "updates"),
  accessibility_link_count = sum(relationships$relationship_type == "reviewsAccessibilityOf"),
  resilience_link_count = sum(relationships$relationship_type == "stewards"),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review)
)

write.csv(object_type_summary, file.path(outputs_dir, "r_future_platform_object_type_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_future_platform_relationship_type_summary.csv"), row.names = FALSE)
write.csv(repository_status_summary, file.path(outputs_dir, "r_future_platform_repository_status_summary.csv"), row.names = FALSE)
write.csv(ai_review_summary, file.path(outputs_dir, "r_future_platform_ai_review_summary.csv"), row.names = FALSE)
write.csv(resilience_status_summary, file.path(outputs_dir, "r_future_platform_resilience_status_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_future_platform_degree_table.csv"), row.names = FALSE)
write.csv(accessibility, file.path(outputs_dir, "r_future_platform_accessibility_diagnostics.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_future_platform_coverage_summary.csv"), row.names = FALSE)

print(object_type_summary)
print(relationship_type_summary)
print(coverage_summary)
