# Lightweight Julia IA/KA alignment metrics.
# Uses only Julia standard library.

using DelimitedFiles
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
        values = split(line, ",")
        push!(rows, Dict(header[i] => values[i] for i in eachindex(header)))
    end
    return rows
end

objects = read_simple_csv(joinpath(data_dir, "information_objects.csv"))
navigation = read_simple_csv(joinpath(data_dir, "navigation_links.csv"))
semantic = read_simple_csv(joinpath(data_dir, "semantic_relationships.csv"))

nav_degree = Dict{String,Int}()
sem_degree = Dict{String,Int}()

for link in navigation
    nav_degree[link["source_object_id"]] = get(nav_degree, link["source_object_id"], 0) + 1
    nav_degree[link["target_object_id"]] = get(nav_degree, link["target_object_id"], 0) + 1
end

for rel in semantic
    sem_degree[rel["source_object_id"]] = get(sem_degree, rel["source_object_id"], 0) + 1
    sem_degree[rel["target_object_id"]] = get(sem_degree, rel["target_object_id"], 0) + 1
end

object_count = length(objects)
navigation_coverage = count(obj -> get(nav_degree, obj["object_id"], 0) > 0, objects) / object_count
semantic_coverage = count(obj -> get(sem_degree, obj["object_id"], 0) > 0, objects) / object_count
metadata_coverage = count(obj -> lowercase(obj["has_metadata_context"]) == "true", objects) / object_count

open(joinpath(outputs_dir, "julia_alignment_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "navigation_coverage,%.3f\n", navigation_coverage)
    @printf(io, "semantic_coverage,%.3f\n", semantic_coverage)
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
end

println("Wrote Julia IA/KA alignment metrics.")
