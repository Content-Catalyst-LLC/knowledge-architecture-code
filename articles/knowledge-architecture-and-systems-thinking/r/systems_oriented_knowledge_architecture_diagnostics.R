# Systems-Oriented Knowledge Architecture Diagnostics
# Base R workflow for feedback, coverage, scale, relationship, and review diagnostics.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "knowledge_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "knowledge_relationships.csv"), stringsAsFactors = FALSE)
feedback_loops <- read.csv(file.path(data_dir, "feedback_loops.csv"), stringsAsFactors = FALSE)
assumptions <- read.csv(file.path(data_dir, "assumptions.csv"), stringsAsFactors = FALSE)

objects$has_metadata <- tolower(objects$has_metadata) == "true"
objects$has_feedback_role <- tolower(objects$has_feedback_role) == "true"
relationships$feedback_relevant <- tolower(relationships$feedback_relevant) == "true"

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

scale_summary <- as.data.frame(table(objects$scale))
names(scale_summary) <- c("scale", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

loop_type_summary <- as.data.frame(table(feedback_loops$loop_type))
names(loop_type_summary) <- c("loop_type", "count")

assumption_sensitivity_summary <- as.data.frame(table(assumptions$sensitivity_level))
names(assumption_sensitivity_summary) <- c("sensitivity_level", "count")

relationship_ids <- c(relationships$source_object_id, relationships$target_object_id)

degree_table <- data.frame(
  object_id = objects$object_id,
  title = objects$title,
  object_type = objects$object_type,
  has_metadata = objects$has_metadata,
  scale = objects$scale,
  has_feedback_role = objects$has_feedback_role,
  status = objects$status,
  degree = sapply(objects$object_id, function(x) sum(relationship_ids == x))
)

degree_table$is_orphan <- degree_table$degree == 0
degree_table$needs_review <- !degree_table$has_metadata |
  degree_table$status == "review_needed" |
  degree_table$is_orphan

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  feedback_loop_count = nrow(feedback_loops),
  assumption_count = nrow(assumptions),
  metadata_coverage = mean(objects$has_metadata),
  feedback_role_coverage = mean(objects$has_feedback_role),
  relationship_traceability = mean(relationships$provenance_note != ""),
  feedback_edge_share = mean(relationships$feedback_relevant),
  underspecified_relationship_risk = mean(relationships$relationship_type %in% c("related", "sameAs", "")),
  scale_count = length(unique(objects$scale)),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review)
)

write.csv(object_type_summary, file.path(outputs_dir, "r_systems_knowledge_object_type_summary.csv"), row.names = FALSE)
write.csv(scale_summary, file.path(outputs_dir, "r_systems_knowledge_scale_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_systems_knowledge_relationship_type_summary.csv"), row.names = FALSE)
write.csv(loop_type_summary, file.path(outputs_dir, "r_systems_knowledge_feedback_loop_type_summary.csv"), row.names = FALSE)
write.csv(assumption_sensitivity_summary, file.path(outputs_dir, "r_systems_knowledge_assumption_sensitivity_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_systems_knowledge_degree_table.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_systems_knowledge_coverage_summary.csv"), row.names = FALSE)

print(object_type_summary)
print(scale_summary)
print(coverage_summary)
