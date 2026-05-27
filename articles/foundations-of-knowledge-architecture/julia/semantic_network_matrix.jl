# Semantic network adjacency matrix for Foundations of Knowledge Architecture.
# Run from the article folder:
#   julia julia/semantic_network_matrix.jl

using DelimitedFiles

concept_rows = readdlm("data/concepts.csv", ',', String; header=true)
relationship_rows = readdlm("data/relationships.csv", ',', String; header=true)

concepts = concept_rows[1]
relationships = relationship_rows[1]
labels = concepts[:, 2]
index = Dict(label => i for (i, label) in enumerate(labels))

adj = zeros(Int, length(labels), length(labels))

for row in eachrow(relationships)
    source = row[1]
    target = row[2]
    if haskey(index, source) && haskey(index, target)
        adj[index[source], index[target]] = 1
    end
end

outdir = "outputs"
isdir(outdir) || mkdir(outdir)
writedlm(joinpath(outdir, "julia_adjacency_matrix.csv"), adj, ',')

println("Wrote outputs/julia_adjacency_matrix.csv")
println("Node count: ", length(labels))
println("Edge count: ", sum(adj))
