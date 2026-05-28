# Governance Knowledge Architecture Diagnostics
# Base R workflow for governance evidence, participation, accountability, equity, traceability, and review diagnostics.

script_path <- tryCatch(normalizePath(sys.frame(1)$ofile), error = function(e) NA)
if (is.na(script_path)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
} else {
  root <- normalizePath(file.path(dirname(script_path), ".."), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "governance_objects.csv"), stringsAsFactors = FALSE)
relationships <- read.csv(file.path(data_dir, "governance_relationships.csv"), stringsAsFactors = FALSE)
institutions <- read.csv(file.path(data_dir, "institutions.csv"), stringsAsFactors = FALSE)
evidence <- read.csv(file.path(data_dir, "evidence_sources.csv"), stringsAsFactors = FALSE)
participation <- read.csv(file.path(data_dir, "participation_records.csv"), stringsAsFactors = FALSE)

objects$has_metadata <- tolower(objects$has_metadata) == "true"
objects$has_accountability_context <- tolower(objects$has_accountability_context) == "true"
objects$has_equity_context <- tolower(objects$has_equity_context) == "true"

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

relationship_type_summary <- as.data.frame(table(relationships$relationship_type))
names(relationship_type_summary) <- c("relationship_type", "count")

institution_type_summary <- as.data.frame(table(institutions$institution_type))
names(institution_type_summary) <- c("institution_type", "count")

evidence_type_summary <- as.data.frame(table(evidence$evidence_type))
names(evidence_type_summary) <- c("evidence_type", "count")

participation_status_summary <- as.data.frame(table(participation$review_status))
names(participation_status_summary) <- c("review_status", "count")

relationship_ids <- c(relationships$source_object_id, relationships$target_object_id)

degree_table <- data.frame(
  object_id = objects$object_id,
  title = objects$title,
  object_type = objects$object_type,
  has_metadata = objects$has_metadata,
  has_accountability_context = objects$has_accountability_context,
  has_equity_context = objects$has_equity_context,
  status = objects$status,
  degree = sapply(objects$object_id, function(x) sum(relationship_ids == x))
)

degree_table$is_orphan <- degree_table$degree == 0
degree_table$needs_review <- !degree_table$has_metadata |
  degree_table$status == "review_needed" |
  degree_table$is_orphan

participation$response_complete <- participation$response_note != "" & participation$influence_note != ""

coverage_summary <- data.frame(
  object_count = nrow(objects),
  relationship_count = nrow(relationships),
  institution_count = nrow(institutions),
  evidence_source_count = nrow(evidence),
  participation_record_count = nrow(participation),
  metadata_coverage = mean(objects$has_metadata),
  accountability_context_coverage = mean(objects$has_accountability_context),
  equity_context_coverage = mean(objects$has_equity_context),
  relationship_traceability = mean(relationships$provenance_note != ""),
  underspecified_relationship_risk = mean(relationships$relationship_type %in% c("related", "sameAs", "")),
  participation_response_coverage = mean(participation$response_complete),
  participation_link_share = mean(relationships$relationship_type %in% c("participatesIn", "informsDecision")),
  review_link_share = mean(relationships$relationship_type %in% c("reviews", "respondsToReview", "revises", "governsReviewOf")),
  orphan_count = sum(degree_table$is_orphan),
  review_needed_count = sum(degree_table$needs_review)
)

write.csv(object_type_summary, file.path(outputs_dir, "r_governance_object_type_summary.csv"), row.names = FALSE)
write.csv(relationship_type_summary, file.path(outputs_dir, "r_governance_relationship_type_summary.csv"), row.names = FALSE)
write.csv(institution_type_summary, file.path(outputs_dir, "r_governance_institution_type_summary.csv"), row.names = FALSE)
write.csv(evidence_type_summary, file.path(outputs_dir, "r_governance_evidence_type_summary.csv"), row.names = FALSE)
write.csv(participation_status_summary, file.path(outputs_dir, "r_governance_participation_status_summary.csv"), row.names = FALSE)
write.csv(degree_table, file.path(outputs_dir, "r_governance_degree_table.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_governance_coverage_summary.csv"), row.names = FALSE)

print(object_type_summary)
print(relationship_type_summary)
print(coverage_summary)
