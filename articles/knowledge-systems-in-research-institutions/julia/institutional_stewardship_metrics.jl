# Institutional Knowledge-System Stewardship Metrics
# Uses only Julia standard library.

using Printf

root = normpath(joinpath(@__DIR__, ".."))
data_dir = joinpath(root, "data")
outputs_dir = joinpath(root, "outputs")
mkpath(outputs_dir)

function read_simple_csv(path)
    lines = readlines(path)
    header = split(lines[1], ",")
    rows = Vector{Dict{String,String}}()
    for line in lines[2:end]
        isempty(strip(line)) && continue
        values = split(line, ",")
        push!(rows, Dict(header[i] => values[i] for i in eachindex(header)))
    end
    return rows
end

objects = read_simple_csv(joinpath(data_dir, "research_objects.csv"))
relationships = read_simple_csv(joinpath(data_dir, "object_relationships.csv"))
governance = read_simple_csv(joinpath(data_dir, "governance_records.csv"))

object_count = length(objects)
relationship_count = length(relationships)

metadata_coverage = count(obj -> lowercase(obj["has_metadata"]) == "true", objects) / object_count
traceability = count(rel -> strip(rel["provenance_note"]) != "", relationships) / relationship_count
governance_current = count(g -> g["review_status"] == "current", governance) / length(governance)

restricted_objects = count(obj -> obj["access_level"] in ["restricted", "community_governed"], objects)
governed_restricted_objects = count(obj -> begin
    if !(obj["access_level"] in ["restricted", "community_governed"])
        return false
    end
    any(g -> g["object_id"] == obj["object_id"], governance)
end, objects)

sensitive_governance_coverage = restricted_objects == 0 ? 1.0 : governed_restricted_objects / restricted_objects

stewardship_score = (metadata_coverage + traceability + governance_current + sensitive_governance_coverage) / 4

open(joinpath(outputs_dir, "julia_institutional_stewardship_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
    @printf(io, "relationship_traceability,%.3f\n", traceability)
    @printf(io, "governance_current_share,%.3f\n", governance_current)
    @printf(io, "sensitive_governance_coverage,%.3f\n", sensitive_governance_coverage)
    @printf(io, "stewardship_score,%.3f\n", stewardship_score)
end

println("Wrote Julia institutional stewardship metrics.")
