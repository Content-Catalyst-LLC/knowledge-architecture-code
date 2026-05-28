# Complex Systems Conceptual Model Metrics
# Uses only Julia standard library.

using Printf

root = normpath(joinpath(@__DIR__, ".."))
outputs_dir = joinpath(root, "outputs")
mkpath(outputs_dir)

component_count = 10
relationship_count = 12
metadata_coverage = 8 / 10
uncertainty_context_coverage = 8 / 10
relationship_traceability = 10 / 12
feedback_edge_share = 8 / 12
underspecified_relationship_risk = 1 / 12

model_quality_score = (
    metadata_coverage +
    uncertainty_context_coverage +
    relationship_traceability +
    feedback_edge_share +
    (1 - underspecified_relationship_risk)
) / 5

open(joinpath(outputs_dir, "julia_complex_system_model_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "component_count,%d\n", component_count)
    @printf(io, "relationship_count,%d\n", relationship_count)
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
    @printf(io, "uncertainty_context_coverage,%.3f\n", uncertainty_context_coverage)
    @printf(io, "relationship_traceability,%.3f\n", relationship_traceability)
    @printf(io, "feedback_edge_share,%.3f\n", feedback_edge_share)
    @printf(io, "underspecified_relationship_risk,%.3f\n", underspecified_relationship_risk)
    @printf(io, "model_quality_score,%.3f\n", model_quality_score)
end

println("Wrote Julia complex systems conceptual model metrics.")
