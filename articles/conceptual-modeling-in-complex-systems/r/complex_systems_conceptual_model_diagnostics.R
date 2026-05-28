# Complex Systems Conceptual Model Diagnostics
# Base R workflow for component, scale, feedback, relationship, and review diagnostics.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

components <- read.csv(file.path(data_dir, "components.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "relationships.csv"), stringsAsFactors = FALSE)
feedback_loops <- read.csv(file.path(data_dir, "feedback_loops.csv"), stringsAsFactors = FALSE)
assumptions <- read.csv(file.path(data_dir, "assumptions.csv"), stringsAsFactors = FALSE)

components$has_metadata <- tolower(components$has_metadata) == "true"
components$has_uncertainty_context <- tolower(components$has_uncertainty_context) == "true"
relationships$feedback_relevant <- tolower(relationships$feedback_relevant) == "true"

component_type_summary <- as.data.frame(table(components$component_type))
names(component_type_summary) <- c("component_type", "count")

scale_summary <- as.data.frame(table(components$scale))
names(scale_summary) <- c("scale", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

loop_type_summary <- as.data.frame(table(feedback_loops$loop_type))
names(loop_type_summary) <- c("loop_type", "count")

assumption_sensitivity_summary <- as.data.frame(table(assumptions$sensitivity_level))
names(assumption_sensitivity_summary) <- c("sensitivity_level", "count")

relationship_ids <- c(relationships$source_component_id, relationships$target_component_id)

degree_table <- data.frame(
  component_id = components$component_id,
  system_id = components$system_id,
  label = components$label,
  component_type = components$component_type,
  has_metadata = components$has_metadata,
  scale = components$scale,
  has_uncertainty_context = components$has_uncertainty_context,
  status = components$status,
  degree = sapply(components$component_id, function(x) sum(relationship_ids == x))
)

degree_table$is_orphan <- degree_table$degree == 0
degree_table$needs_review <- !degree_table$has_metadata |
  degree_table$status == "review_needed" |
  degree_table$is_orphan

coverage_summary <- data.frame(
  component_count = nrow(components),
  relationship_count = nrow(relationships),
  feedback_loop_count = nrow(feedback_loops),
  assumption_count = nrow(assumptions),
  metadata_coverage = mean(components$has_metadata),
  uncertainty_context_coverage = mean(components$has_uncertainty_context),
  relationship_traceability = mean(relationships$provenance_note != ""),
  feedback_edge_share = mean(relationships$feedback_relevant),
  underspecified_relationship_risk = mean(relationships$relationship_type %in% c("related", "sameAs", "")),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review)
)

write.csv(component_type_summary, file.path(outputs_dir, "r_complex_system_component_type_summary.csv"), row.names = FALSE)
write.csv(scale_summary, file.path(outputs_dir, "r_complex_system_scale_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_complex_system_relationship_type_summary.csv"), row.names = FALSE)
write.csv(loop_type_summary, file.path(outputs_dir, "r_complex_system_feedback_loop_type_summary.csv"), row.names = FALSE)
write.csv(assumption_sensitivity_summary, file.path(outputs_dir, "r_complex_system_assumption_sensitivity_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_complex_system_degree_table.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_complex_system_coverage_summary.csv"), row.names = FALSE)

print(component_type_summary)
print(scale_summary)
print(coverage_summary)
