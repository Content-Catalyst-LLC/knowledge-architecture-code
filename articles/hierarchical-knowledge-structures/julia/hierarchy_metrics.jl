# hierarchy_metrics.jl
# Lightweight hierarchy metrics using only Julia standard library.

using DelimitedFiles
using Statistics

function read_csv(path)
    data = readdlm(path, ',', String)
    header = data[1, :]
    rows = data[2:end, :]
    return header, rows
end

nodes_header, nodes = read_csv("data/hierarchy_nodes.csv")
edges_header, edges = read_csv("data/hierarchy_edges.csv")

node_ids = nodes[:, 1]
children = Dict{String, Vector{String}}()
parents = Dict{String, Vector{String}}()

for id in node_ids
    children[id] = String[]
    parents[id] = String[]
end

for row in eachrow(edges)
    parent = row[1]
    child = row[2]
    if haskey(children, parent)
        push!(children[parent], child)
    end
    if haskey(parents, child)
        push!(parents[child], parent)
    end
end

roots = [id for id in node_ids if length(parents[id]) == 0]

depths = Dict{String, Int}()
queue = [(root, 0) for root in roots]

while !isempty(queue)
    item = popfirst!(queue)
    node_id, depth = item

    if !haskey(depths, node_id) || depth < depths[node_id]
        depths[node_id] = depth
        for child in children[node_id]
            push!(queue, (child, depth + 1))
        end
    end
end

depth_values = collect(values(depths))
child_counts = [length(children[id]) for id in node_ids]
leaf_count = count(x -> x == 0, child_counts)

mkpath("outputs")

open("outputs/julia_hierarchy_summary.csv", "w") do io
    println(io, "metric,value")
    println(io, "node_count,$(length(node_ids))")
    println(io, "edge_count,$(size(edges, 1))")
    println(io, "root_count,$(length(roots))")
    println(io, "max_depth,$(maximum(depth_values))")
    println(io, "mean_depth,$(mean(depth_values))")
    println(io, "leaf_count,$leaf_count")
    println(io, "leaf_rate,$(leaf_count / length(node_ids))")
end

println("Wrote outputs/julia_hierarchy_summary.csv")
