# AI Knowledge Organization Metrics
# Uses only Julia standard library.

using Printf

root = normpath(joinpath(@__DIR__, ".."))
outputs_dir = joinpath(root, "outputs")
mkpath(outputs_dir)

object_count = 14
relationship_count = 15
metadata_coverage = 13 / 14
provenance_coverage = 11 / 14
review_context_coverage = 11 / 14
relationship_traceability = 14 / 15
retrieval_review_coverage = 5 / 6
underspecified_relationship_risk = 1 / 15

ai_ko_quality_score = (
    metadata_coverage +
    provenance_coverage +
    review_context_coverage +
    relationship_traceability +
    retrieval_review_coverage +
    (1 - underspecified_relationship_risk)
) / 6

open(joinpath(outputs_dir, "julia_ai_knowledge_organization_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "object_count,%d\n", object_count)
    @printf(io, "relationship_count,%d\n", relationship_count)
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
    @printf(io, "provenance_coverage,%.3f\n", provenance_coverage)
    @printf(io, "review_context_coverage,%.3f\n", review_context_coverage)
    @printf(io, "relationship_traceability,%.3f\n", relationship_traceability)
    @printf(io, "retrieval_review_coverage,%.3f\n", retrieval_review_coverage)
    @printf(io, "underspecified_relationship_risk,%.3f\n", underspecified_relationship_risk)
    @printf(io, "ai_ko_quality_score,%.3f\n", ai_ko_quality_score)
end

println("Wrote Julia AI knowledge organization metrics.")
