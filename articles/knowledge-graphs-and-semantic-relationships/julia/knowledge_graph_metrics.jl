# Lightweight graph metrics scaffold for Knowledge Graphs and Semantic Relationships.

using DelimitedFiles

function read_edges(path::String)
    rows = readdlm(path, ',', String)
    header = rows[1, :]
    body = rows[2:end, :]
    return header, body
end

header, edges = read_edges("data/edges.csv")
source_idx = findfirst(==("source_node_id"), header)
target_idx = findfirst(==("target_node_id"), header)
relationship_idx = findfirst(==("relationship_type_id"), header)

nodes = Set{String}()
relationship_counts = Dict{String, Int}()
degree = Dict{String, Int}()

for i in 1:size(edges, 1)
    source = edges[i, source_idx]
    target = edges[i, target_idx]
    rel = edges[i, relationship_idx]
    push!(nodes, source)
    push!(nodes, target)
    degree[source] = get(degree, source, 0) + 1
    degree[target] = get(degree, target, 0) + 1
    relationship_counts[rel] = get(relationship_counts, rel, 0) + 1
end

mkpath("outputs")
open("outputs/julia_graph_metrics.txt", "w") do io
    println(io, "node_count=", length(nodes))
    println(io, "edge_count=", size(edges, 1))
    println(io, "relationship_type_count=", length(keys(relationship_counts)))
    println(io, "max_degree=", maximum(values(degree)))
end

println("Wrote outputs/julia_graph_metrics.txt")
