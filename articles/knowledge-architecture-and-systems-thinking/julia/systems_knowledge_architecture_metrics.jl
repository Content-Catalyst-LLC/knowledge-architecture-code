# Systems-Oriented Knowledge Architecture Metrics
# Uses only Julia standard library.

using Printf

root = normpath(joinpath(@__DIR__, ".."))
outputs_dir = joinpath(root, "outputs")
mkpath(outputs_dir)

object_count = 12
relationship_count = 14
metadata_coverage = 11 / 12
feedback_role_coverage = 8 / 12
relationship_traceability = 13 / 14
feedback_edge_share = 6 / 14
underspecified_relationship_risk = 1 / 14

systems_quality_score = (
    metadata_coverage +
    feedback_role_coverage +
    relationship_traceability +
    feedback_edge_share +
    (1 - underspecified_relationship_risk)
) / 5

open(joinpath(outputs_dir, "julia_systems_knowledge_architecture_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "object_count,%d\n", object_count)
    @printf(io, "relationship_count,%d\n", relationship_count)
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
    @printf(io, "feedback_role_coverage,%.3f\n", feedback_role_coverage)
    @printf(io, "relationship_traceability,%.3f\n", relationship_traceability)
    @printf(io, "feedback_edge_share,%.3f\n", feedback_edge_share)
    @printf(io, "underspecified_relationship_risk,%.3f\n", underspecified_relationship_risk)
    @printf(io, "systems_quality_score,%.3f\n", systems_quality_score)
end

println("Wrote Julia systems-oriented knowledge architecture metrics.")
