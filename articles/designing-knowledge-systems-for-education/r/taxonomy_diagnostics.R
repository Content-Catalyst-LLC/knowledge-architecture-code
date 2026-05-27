# Minimal taxonomy diagnostics for article-level knowledge architecture.
# Run from the article folder:
#   Rscript r/taxonomy_diagnostics.R

concepts <- read.csv("data/synthetic/concepts.csv")
relationships <- read.csv("data/synthetic/relationships.csv")

dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

domain_summary <- aggregate(
  concept_id ~ domain,
  data = concepts,
  FUN = length
)

names(domain_summary) <- c("domain", "concept_count")

write.csv(
  domain_summary,
  "outputs/tables/article_domain_summary.csv",
  row.names = FALSE
)

print(domain_summary)
