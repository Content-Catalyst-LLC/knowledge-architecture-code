# Semantic-network metrics scaffold for Ontologies and Semantic Networks.
# Uses only Julia standard library modules.

using DelimitedFiles
using Statistics

println("Semantic network metrics scaffold")
println("Extend this file with graph centrality, connected components, ontology checks, or RDF export support.")

edges_path = joinpath(@__DIR__, "..", "data", "edges.csv")
if isfile(edges_path)
    edges = readdlm(edges_path, ',', String, '\n')
    println("Loaded edge table rows: ", size(edges, 1))
else
    println("No edge table found.")
end
