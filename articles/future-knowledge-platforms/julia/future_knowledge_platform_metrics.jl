# Future Knowledge Platform Metrics
# Uses only Julia standard library.

using Printf

root = normpath(joinpath(@__DIR__, ".."))
outputs_dir = joinpath(root, "outputs")
mkpath(outputs_dir)

object_count = 14
relationship_count = 14
metadata_coverage = 13 / 14
provenance_coverage = 12 / 14
reuse_context_coverage = 11 / 14
review_context_coverage = 11 / 14
relationship_traceability = 13 / 14
accessibility_mean_completeness = 11 / 15
underspecified_relationship_risk = 1 / 14

platform_quality_score = (
    metadata_coverage +
    provenance_coverage +
    reuse_context_coverage +
    review_context_coverage +
    relationship_traceability +
    accessibility_mean_completeness +
    (1 - underspecified_relationship_risk)
) / 7

open(joinpath(outputs_dir, "julia_future_knowledge_platform_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "object_count,%d\n", object_count)
    @printf(io, "relationship_count,%d\n", relationship_count)
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
    @printf(io, "provenance_coverage,%.3f\n", provenance_coverage)
    @printf(io, "reuse_context_coverage,%.3f\n", reuse_context_coverage)
    @printf(io, "review_context_coverage,%.3f\n", review_context_coverage)
    @printf(io, "relationship_traceability,%.3f\n", relationship_traceability)
    @printf(io, "accessibility_mean_completeness,%.3f\n", accessibility_mean_completeness)
    @printf(io, "underspecified_relationship_risk,%.3f\n", underspecified_relationship_risk)
    @printf(io, "platform_quality_score,%.3f\n", platform_quality_score)
end

println("Wrote Julia future knowledge platform metrics.")
