# Educational Knowledge System Metrics
# Uses only Julia standard library.

using Printf

root = normpath(joinpath(@__DIR__, ".."))
outputs_dir = joinpath(root, "outputs")
mkpath(outputs_dir)

object_count = 14
relationship_count = 16
metadata_coverage = 13 / 14
accessibility_context_coverage = 13 / 14
review_context_coverage = 12 / 14
relationship_traceability = 15 / 16
underspecified_relationship_risk = 1 / 16
accessibility_record_mean_completeness = 0.8

education_quality_score = (
    metadata_coverage +
    accessibility_context_coverage +
    review_context_coverage +
    relationship_traceability +
    accessibility_record_mean_completeness +
    (1 - underspecified_relationship_risk)
) / 6

open(joinpath(outputs_dir, "julia_educational_knowledge_system_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "object_count,%d\n", object_count)
    @printf(io, "relationship_count,%d\n", relationship_count)
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
    @printf(io, "accessibility_context_coverage,%.3f\n", accessibility_context_coverage)
    @printf(io, "review_context_coverage,%.3f\n", review_context_coverage)
    @printf(io, "relationship_traceability,%.3f\n", relationship_traceability)
    @printf(io, "underspecified_relationship_risk,%.3f\n", underspecified_relationship_risk)
    @printf(io, "accessibility_record_mean_completeness,%.3f\n", accessibility_record_mean_completeness)
    @printf(io, "education_quality_score,%.3f\n", education_quality_score)
end

println("Wrote Julia educational knowledge-system metrics.")
