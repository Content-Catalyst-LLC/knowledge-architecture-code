# Decision Knowledge System Diagnostics
# Base R workflow for decision evidence, equity, review, traceability, and feedback diagnostics.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "decision_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "decision_relationships.csv"), stringsAsFactors = FALSE)
criteria <- read.csv(file.path(data_dir, "decision_criteria.csv"), stringsAsFactors = FALSE)
scores <- read.csv(file.path(data_dir, "option_scores.csv"), stringsAsFactors = FALSE)
actors <- read.csv(file.path(data_dir, "actors.csv"), stringsAsFactors = FALSE)
evidence <- read.csv(file.path(data_dir, "evidence_sources.csv"), stringsAsFactors = FALSE)

objects$has_metadata <- tolower(objects$has_metadata) == "true"
objects$has_equity_context <- tolower(objects$has_equity_context) == "true"
objects$has_review_context <- tolower(objects$has_review_context) == "true"

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

actor_type_summary <- as.data.frame(table(actors$actor_type))
names(actor_type_summary) <- c("actor_type", "count")

evidence_type_summary <- as.data.frame(table(evidence$evidence_type))
names(evidence_type_summary) <- c("evidence_type", "count")

relationship_ids <- c(relationships$source_object_id, relationships$target_object_id)

degree_table <- data.frame(
  object_id = objects$object_id,
  title = objects$title,
  object_type = objects$object_type,
  has_metadata = objects$has_metadata,
  has_equity_context = objects$has_equity_context,
  has_review_context = objects$has_review_context,
  status = objects$status,
  degree = sapply(objects$object_id, function(x) sum(relationship_ids == x))
)

degree_table$is_orphan <- degree_table$degree == 0
degree_table$needs_review <- !degree_table$has_metadata |
  degree_table$status == "review_needed" |
  degree_table$is_orphan

score_table <- merge(scores, criteria[, c("criterion_id", "weight")], by = "criterion_id")
score_table$weighted_component <- score_table$score * score_table$weight

option_scores <- aggregate(
  cbind(weighted_component, weight) ~ option_id,
  data = score_table,
  FUN = sum
)
option_scores$weighted_score <- option_scores$weighted_component / option_scores$weight

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  metadata_coverage = mean(objects$has_metadata),
  equity_context_coverage = mean(objects$has_equity_context),
  review_context_coverage = mean(objects$has_review_context),
  relationship_traceability = mean(relationships$provenance_note != ""),
  underspecified_relationship_risk = mean(relationships$relationship_type %in% c("related", "sameAs", "")),
  feedback_link_share = mean(grepl("feedback|feedsBack", relationships$relationship_type, ignore.case = TRUE)),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review)
)

write.csv(object_type_summary, file.path(outputs_dir, "r_decision_object_type_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_decision_relationship_type_summary.csv"), row.names = FALSE)
write.csv(actor_type_summary, file.path(outputs_dir, "r_decision_actor_type_summary.csv"), row.names = FALSE)
write.csv(evidence_type_summary, file.path(outputs_dir, "r_decision_evidence_type_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_decision_degree_table.csv"), row.names = FALSE)
write.csv(option_scores, file.path(outputs_dir, "r_decision_option_weighted_scores.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_decision_coverage_summary.csv"), row.names = FALSE)

print(object_type_summary)
print(option_scores)
print(coverage_summary)
