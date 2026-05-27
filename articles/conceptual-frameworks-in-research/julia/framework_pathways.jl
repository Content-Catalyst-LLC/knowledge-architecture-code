# Lightweight conceptual framework pathway scaffold.
# Run from articles/conceptual-frameworks-in-research:
#   julia julia/framework_pathways.jl

using DelimitedFiles

concept_file = "data/framework_concepts.csv"
relationship_file = "data/framework_relationships.csv"

if !isfile(concept_file)
    error("Run from the article folder: articles/conceptual-frameworks-in-research")
end

concepts = readdlm(concept_file, ',', String)
relationships = readdlm(relationship_file, ',', String)

concept_count = size(concepts, 1) - 1
relationship_count = size(relationships, 1) - 1

println("Conceptual Framework Pathway Summary")
println("Concepts: ", concept_count)
println("Relationships: ", relationship_count)

type_counts = Dict{String, Int}()

for i in 2:size(relationships, 1)
    relationship_type = relationships[i, 3]
    type_counts[relationship_type] = get(type_counts, relationship_type, 0) + 1
end

println("Relationship types:")
for key in sort(collect(keys(type_counts)))
    println(" - ", key, ": ", type_counts[key])
end

mkpath("outputs")
open("outputs/julia_framework_summary.txt", "w") do io
    println(io, "Conceptual Framework Pathway Summary")
    println(io, "Concepts: ", concept_count)
    println(io, "Relationships: ", relationship_count)
    println(io, "Relationship types:")
    for key in sort(collect(keys(type_counts)))
        println(io, " - ", key, ": ", type_counts[key])
    end
end
