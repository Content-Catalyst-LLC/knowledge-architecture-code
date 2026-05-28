# Scientific Collaboration Knowledge System Metrics
# Uses only Julia standard library.

using Printf

root = normpath(joinpath(@__DIR__, ".."))
outputs_dir = joinpath(root, "outputs")
mkpath(outputs_dir)

object_count = 14
relationship_count = 16
metadata_coverage = 13 / 14
provenance_coverage = 13 / 14
review_context_coverage = 11 / 14
relationship_traceability = 15 / 16
underspecified_relationship_risk = 1 / 16
contributor_role_count = 7
reproducibility_link_count = 6

collaboration_quality_score = (
    metadata_coverage +
    provenance_coverage +
    review_context_coverage +
    relationship_traceability +
    (1 - underspecified_relationship_risk)
) / 5

open(joinpath(outputs_dir, "julia_scientific_collaboration_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "object_count,%d\n", object_count)
    @printf(io, "relationship_count,%d\n", relationship_count)
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
    @printf(io, "provenance_coverage,%.3f\n", provenance_coverage)
    @printf(io, "review_context_coverage,%.3f\n", review_context_coverage)
    @printf(io, "relationship_traceability,%.3f\n", relationship_traceability)
    @printf(io, "underspecified_relationship_risk,%.3f\n", underspecified_relationship_risk)
    @printf(io, "contributor_role_count,%d\n", contributor_role_count)
    @printf(io, "reproducibility_link_count,%d\n", reproducibility_link_count)
    @printf(io, "collaboration_quality_score,%.3f\n", collaboration_quality_score)
end

println("Wrote Julia scientific collaboration metrics.")
