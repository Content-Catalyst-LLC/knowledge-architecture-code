# What Is Knowledge Architecture?
# Lightweight semantic-network metrics using Julia standard library.

using DelimitedFiles
using Statistics

concepts_path = joinpath("data", "concepts.csv")
relationships_path = joinpath("data", "relationships.csv")

concept_rows = readdlm(concepts_path, ',', String)
relationship_rows = readdlm(relationships_path, ',', String)

concept_labels = concept_rows[2:end, 2]
depth_values = parse.(Int, concept_rows[2:end, 4])

degree = Dict(label => 0 for label in concept_labels)

for row in eachrow(relationship_rows[2:end, :])
    source = row[1]
    target = row[2]
    degree[source] = get(degree, source, 0) + 1
    degree[target] = get(degree, target, 0) + 1
end

mkpath("outputs")

open(joinpath("outputs", "julia_degree_summary.csv"), "w") do io
    println(io, "concept,degree")
    for key in sort(collect(keys(degree)))
        println(io, "$(key),$(degree[key])")
    end
end

open(joinpath("outputs", "julia_depth_summary.txt"), "w") do io
    println(io, "concept_count=$(length(concept_labels))")
    println(io, "max_depth=$(maximum(depth_values))")
    println(io, "mean_depth=$(mean(depth_values))")
    println(io, "median_depth=$(median(depth_values))")
end

println("Wrote Julia semantic-network outputs.")
