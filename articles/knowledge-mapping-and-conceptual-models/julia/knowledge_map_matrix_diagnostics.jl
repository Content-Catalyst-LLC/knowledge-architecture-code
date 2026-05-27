# Knowledge Mapping and Conceptual Models
# Matrix-style diagnostics for a small conceptual map.

using DelimitedFiles

root = dirname(dirname(@__FILE__))
outputs = joinpath(root, "outputs")
mkpath(outputs)

concepts = [
    "knowledge_mapping",
    "conceptual_model",
    "taxonomy",
    "ontology",
    "knowledge_graph",
    "metadata",
    "evidence_map",
    "repository",
    "ai_retrieval"
]

edges = [
    ("knowledge_mapping", "conceptual_model"),
    ("knowledge_mapping", "taxonomy"),
    ("knowledge_mapping", "ontology"),
    ("knowledge_mapping", "knowledge_graph"),
    ("metadata", "evidence_map"),
    ("repository", "conceptual_model"),
    ("knowledge_graph", "ai_retrieval"),
    ("ontology", "knowledge_graph"),
    ("taxonomy", "metadata")
]

index = Dict(c => i for (i, c) in enumerate(concepts))
adj = zeros(Int, length(concepts), length(concepts))

for (src, dst) in edges
    adj[index[src], index[dst]] = 1
end

out_degree = vec(sum(adj, dims=2))
in_degree = vec(sum(adj, dims=1))
total_degree = out_degree .+ in_degree

open(joinpath(outputs, "julia_matrix_degree_summary.csv"), "w") do io
    println(io, "concept,in_degree,out_degree,total_degree")
    for i in eachindex(concepts)
        println(io, "$(concepts[i]),$(in_degree[i]),$(out_degree[i]),$(total_degree[i])")
    end
end

open(joinpath(outputs, "julia_map_summary.csv"), "w") do io
    println(io, "metric,value")
    println(io, "concept_count,$(length(concepts))")
    println(io, "edge_count,$(length(edges))")
    println(io, "density,$(round(length(edges) / (length(concepts) * (length(concepts) - 1)), digits=4))")
end

println("Wrote Julia matrix diagnostics to outputs/")
