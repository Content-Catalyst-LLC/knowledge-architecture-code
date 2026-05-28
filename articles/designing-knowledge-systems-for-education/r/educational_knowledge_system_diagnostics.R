# Educational Knowledge System Diagnostics
# Base R workflow for learning pathway, assessment alignment, accessibility, and review diagnostics.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "educational_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "educational_relationships.csv"), stringsAsFactors = FALSE)
resources <- read.csv(file.path(data_dir, "learning_resources.csv"), stringsAsFactors = FALSE)
accessibility <- read.csv(file.path(data_dir, "accessibility_metadata.csv"), stringsAsFactors = FALSE)
objectives <- read.csv(file.path(data_dir, "learning_objectives.csv"), stringsAsFactors = FALSE)

objects$has_metadata <- tolower(objects$has_metadata) == "true"
objects$has_accessibility_context <- tolower(objects$has_accessibility_context) == "true"
objects$has_review_context <- tolower(objects$has_review_context) == "true"

accessibility$has_alt_text <- tolower(accessibility$has_alt_text) == "true"
accessibility$has_captions <- tolower(accessibility$has_captions) == "true"
accessibility$has_transcript <- tolower(accessibility$has_transcript) == "true"
accessibility$keyboard_accessible <- tolower(accessibility$keyboard_accessible) == "true"

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

resource_type_summary <- as.data.frame(table(resources$resource_type))
names(resource_type_summary) <- c("resource_type", "count")

difficulty_summary <- as.data.frame(table(resources$difficulty_level))
names(difficulty_summary) <- c("difficulty_level", "count")

cognitive_level_summary <- as.data.frame(table(objectives$cognitive_level))
names(cognitive_level_summary) <- c("cognitive_level", "count")

relationship_ids <- c(relationships$source_object_id, relationships$target_object_id)

degree_table <- data.frame(
  object_id = objects$object_id,
  title = objects$title,
  object_type = objects$object_type,
  has_metadata = objects$has_metadata,
  has_accessibility_context = objects$has_accessibility_context,
  has_review_context = objects$has_review_context,
  status = objects$status,
  degree = sapply(objects$object_id, function(x) sum(relationship_ids == x))
)

degree_table$is_orphan <- degree_table$degree == 0
degree_table$needs_review <- !degree_table$has_metadata |
  !degree_table$has_accessibility_context |
  !degree_table$has_review_context |
  degree_table$status == "review_needed" |
  degree_table$is_orphan

accessibility$accessibility_completeness <- rowMeans(
  accessibility[, c("has_alt_text", "has_captions", "has_transcript", "keyboard_accessible")]
)

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  resource_count = nrow(resources),
  learning_objective_count = nrow(objectives),
  metadata_coverage = mean(objects$has_metadata),
  accessibility_context_coverage = mean(objects$has_accessibility_context),
  review_context_coverage = mean(objects$has_review_context),
  relationship_traceability = mean(relationships$provenance_note != ""),
  underspecified_relationship_risk = mean(relationships$relationship_type %in% c("related", "sameAs", "")),
  assessment_alignment_links = sum(relationships$relationship_type == "assessesObjective"),
  feedback_link_count = sum(relationships$relationship_type %in% c("generatesFeedback", "feedsBackTo")),
  objective_link_count = sum(grepl("Objective", relationships$relationship_type)),
  accessibility_record_mean_completeness = mean(accessibility$accessibility_completeness),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review)
)

write.csv(object_type_summary, file.path(outputs_dir, "r_educational_object_type_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_educational_relationship_type_summary.csv"), row.names = FALSE)
write.csv(resource_type_summary, file.path(outputs_dir, "r_educational_resource_type_summary.csv"), row.names = FALSE)
write.csv(difficulty_summary, file.path(outputs_dir, "r_educational_resource_difficulty_summary.csv"), row.names = FALSE)
write.csv(cognitive_level_summary, file.path(outputs_dir, "r_educational_cognitive_level_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_educational_degree_table.csv"), row.names = FALSE)
write.csv(accessibility, file.path(outputs_dir, "r_educational_accessibility_diagnostics.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_educational_coverage_summary.csv"), row.names = FALSE)

print(object_type_summary)
print(relationship_type_summary)
print(coverage_summary)
