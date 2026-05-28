# Decision Knowledge System Metrics
# Uses only Julia standard library.

using Printf

root = normpath(joinpath(@__DIR__, ".."))
outputs_dir = joinpath(root, "outputs")
mkpath(outputs_dir)

object_count = 14
relationship_count = 16
metadata_coverage = 13 / 14
equity_context_coverage = 9 / 14
review_context_coverage = 11 / 14
relationship_traceability = 15 / 16
underspecified_relationship_risk = 1 / 16
feedback_link_share = 1 / 16

decision_system_quality_score = (
    metadata_coverage +
    equity_context_coverage +
    review_context_coverage +
    relationship_traceability +
    (1 - underspecified_relationship_risk)
) / 5

open(joinpath(outputs_dir, "julia_decision_knowledge_system_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "object_count,%d\n", object_count)
    @printf(io, "relationship_count,%d\n", relationship_count)
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
    @printf(io, "equity_context_coverage,%.3f\n", equity_context_coverage)
    @printf(io, "review_context_coverage,%.3f\n", review_context_coverage)
    @printf(io, "relationship_traceability,%.3f\n", relationship_traceability)
    @printf(io, "underspecified_relationship_risk,%.3f\n", underspecified_relationship_risk)
    @printf(io, "feedback_link_share,%.3f\n", feedback_link_share)
    @printf(io, "decision_system_quality_score,%.3f\n", decision_system_quality_score)
end

println("Wrote Julia decision knowledge-system metrics.")
