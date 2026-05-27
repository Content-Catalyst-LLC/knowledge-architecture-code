# Interdisciplinary Knowledge Structure Diagnostics
# Base R workflow for concept coverage, discipline distribution, and crosswalk review.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

concepts <- read.csv(file.path(data_dir, "concepts.csv"), stringsAsFactors = FALSE)
crosswalks <- read.csv(file.path(data_dir, "concept_crosswalks.csv"), stringsAsFactors = FALSE)
methods <- read.csv(file.path(data_dir, "methods.csv"), stringsAsFactors = FALSE)
governance <- read.csv(file.path(data_dir, "governance_checks.csv"), stringsAsFactors = FALSE)

concepts$has_scope_note <- tolower(concepts$has_scope_note) == "true"
concepts$has_method_context <- tolower(concepts$has_method_context) == "true"

discipline_summary <- as.data.frame(table(concepts$discipline_id))
names(discipline_summary) <- c("discipline_id", "concept_count")

relationship_type_summary <- as.data.frame(table(crosswalks$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

method_type_summary <- as.data.frame(table(methods$method_type))
names(method_type_summary) <- c("method_type", "count")

crosswalk_ids <- c(crosswalks$source_concept_id, crosswalks$target_concept_id)

degree_table <- data.frame(
  concept_id = concepts$concept_id,
  preferred_label = concepts$preferred_label,
  discipline_id = concepts$discipline_id,
  has_scope_note = concepts$has_scope_note,
  has_method_context = concepts$has_method_context,
  status = concepts$status,
  crosswalk_degree = sapply(concepts$concept_id, function(x) sum(crosswalk_ids == x))
)

degree_table$is_orphan <- degree_table$crosswalk_degree == 0
degree_table$needs_review <- !degree_table$has_scope_note |
  !degree_table$has_method_context |
  degree_table$status == "review_needed" |
  degree_table$is_orphan

governance_summary <- as.data.frame(table(governance$layer, governance$severity))
names(governance_summary) <- c("layer", "severity", "count")

coverage_summary <- data.frame(
  concept_count = nrow(concepts),
  crosswalk_count = nrow(crosswalks),
  discipline_count = length(unique(concepts$discipline_id)),
  method_count = nrow(methods),
  scope_note_coverage = mean(concepts$has_scope_note),
  method_context_coverage = mean(concepts$has_method_context),
  relationship_traceability = mean(crosswalks$provenance_note != ""),
  false_equivalence_risk = mean(crosswalks$relationship_type %in% c("related", "sameAs", "")),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review)
)

write.csv(discipline_summary, file.path(outputs_dir, "r_interdisciplinary_discipline_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_interdisciplinary_relationship_type_summary.csv"), row.names = FALSE)
write.csv(method_type_summary, file.path(outputs_dir, "r_interdisciplinary_method_type_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_interdisciplinary_degree_table.csv"), row.names = FALSE)
write.csv(governance_summary, file.path(outputs_dir, "r_interdisciplinary_governance_summary.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_interdisciplinary_coverage_summary.csv"), row.names = FALSE)

print(discipline_summary)
print(relationship_type_summary)
print(coverage_summary)
