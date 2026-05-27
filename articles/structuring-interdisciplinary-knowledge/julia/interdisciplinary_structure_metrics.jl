# Interdisciplinary Structure Metrics
# Uses only Julia standard library.

using Printf

root = normpath(joinpath(@__DIR__, ".."))
outputs_dir = joinpath(root, "outputs")
mkpath(outputs_dir)

concept_count = 8
crosswalk_count = 6
scope_note_coverage = 7 / 8
method_context_coverage = 7 / 8
relationship_traceability = 5 / 6
false_equivalence_risk = 1 / 6

# Composite review score: higher is better.
structure_quality_score = (
    scope_note_coverage +
    method_context_coverage +
    relationship_traceability +
    (1 - false_equivalence_risk)
) / 4

open(joinpath(outputs_dir, "julia_interdisciplinary_structure_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "concept_count,%d\n", concept_count)
    @printf(io, "crosswalk_count,%d\n", crosswalk_count)
    @printf(io, "scope_note_coverage,%.3f\n", scope_note_coverage)
    @printf(io, "method_context_coverage,%.3f\n", method_context_coverage)
    @printf(io, "relationship_traceability,%.3f\n", relationship_traceability)
    @printf(io, "false_equivalence_risk,%.3f\n", false_equivalence_risk)
    @printf(io, "structure_quality_score,%.3f\n", structure_quality_score)
end

println("Wrote Julia interdisciplinary structure metrics.")
