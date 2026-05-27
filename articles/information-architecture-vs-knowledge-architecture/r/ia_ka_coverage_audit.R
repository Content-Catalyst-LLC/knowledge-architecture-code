# IA vs KA coverage audit using base R.
# Produces coverage summaries for navigation, semantic relationships, and metadata context.

root <- normalizePath(file.path(dirname(sys.frame(1)$ofile %||% "r"), ".."), mustWork = FALSE)
if (!dir.exists(root)) {
  root <- normalizePath(file.path(getwd()), mustWork = FALSE)
}

data_dir <- file.path(root, "data")
outputs_dir <- file.path(root, "outputs")
dir.create(outputs_dir, showWarnings = FALSE, recursive = TRUE)

objects <- read.csv(file.path(data_dir, "information_objects.csv"), stringsAsFactors = FALSE)
navigation <- read.csv(file.path(data_dir, "navigation_links.csv"), stringsAsFactors = FALSE)
semantic <- read.csv(file.path(data_dir, "semantic_relationships.csv"), stringsAsFactors = FALSE)

nav_ids <- c(navigation$source_object_id, navigation$target_object_id)
sem_ids <- c(semantic$source_object_id, semantic$target_object_id)

objects$navigation_degree <- sapply(objects$object_id, function(x) sum(nav_ids == x))
objects$semantic_degree <- sapply(objects$object_id, function(x) sum(sem_ids == x))
objects$has_metadata_context <- tolower(objects$has_metadata_context) == "true"

objects$alignment_issue <- ifelse(
  objects$navigation_degree > 0 & objects$semantic_degree == 0,
  "Navigable but semantically underdeveloped",
  ifelse(
    objects$semantic_degree > 0 & objects$navigation_degree == 0,
    "Semantically connected but weakly visible",
    ifelse(!objects$has_metadata_context, "Missing metadata context", "")
  )
)

object_type_summary <- as.data.frame(table(objects$object_type))
names(object_type_summary) <- c("object_type", "count")

coverage_summary <- data.frame(
  object_count = nrow(objects),
  navigation_coverage = mean(objects$navigation_degree > 0),
  semantic_coverage = mean(objects$semantic_degree > 0),
  metadata_context_coverage = mean(objects$has_metadata_context),
  alignment_issue_count = sum(objects$alignment_issue != "")
)

relationship_summary <- as.data.frame(table(semantic$relationship_type))
names(relationship_summary) <- c("relationship_type", "count")

write.csv(objects, file.path(outputs_dir, "r_ia_ka_alignment_table.csv"), row.names = FALSE)
write.csv(object_type_summary, file.path(outputs_dir, "r_object_type_summary.csv"), row.names = FALSE)
write.csv(coverage_summary, file.path(outputs_dir, "r_coverage_summary.csv"), row.names = FALSE)
write.csv(relationship_summary, file.path(outputs_dir, "r_relationship_summary.csv"), row.names = FALSE)

print(coverage_summary)
print(object_type_summary)
print(relationship_summary)

`%||%` <- function(x, y) if (is.null(x)) y else x
