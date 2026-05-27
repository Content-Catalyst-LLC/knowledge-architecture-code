# Intellectual Infrastructure Quality Metrics
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

objects = read_simple_csv(joinpath(data_dir, "infrastructure_objects.csv"))
relationships = read_simple_csv(joinpath(data_dir, "infrastructure_relationships.csv"))
repo_alignment_rows = read_simple_csv(joinpath(data_dir, "repository_alignment.csv"))

object_count = length(objects)
relationship_count = length(relationships)

metadata_coverage = count(obj -> lowercase(obj["has_metadata"]) == "true", objects) / object_count
governance_coverage = count(obj -> lowercase(obj["has_governance"]) == "true", objects) / object_count
traceability = count(rel -> strip(rel["provenance_note"]) != "", relationships) / relationship_count
repository_alignment = count(row -> lowercase(row["folder_exists_in_scaffold"]) == "true", repo_alignment_rows) / length(repo_alignment_rows)

infrastructure_quality_score = (metadata_coverage + governance_coverage + traceability + repository_alignment) / 4

open(joinpath(outputs_dir, "julia_infrastructure_quality_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
    @printf(io, "governance_coverage,%.3f\n", governance_coverage)
    @printf(io, "relationship_traceability,%.3f\n", traceability)
    @printf(io, "repository_alignment,%.3f\n", repository_alignment)
    @printf(io, "infrastructure_quality_score,%.3f\n", infrastructure_quality_score)
end

println("Wrote Julia infrastructure quality metrics.")
