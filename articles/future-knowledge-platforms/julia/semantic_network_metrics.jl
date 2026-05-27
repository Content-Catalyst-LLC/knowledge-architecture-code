# Minimal semantic-network metric scaffold for article-level knowledge architecture.
# Run from the article folder:
#   julia julia/semantic_network_metrics.jl

using DelimitedFiles

relationships_file = "data/synthetic/relationships.csv"
println("Semantic-network scaffold ready for: ", relationships_file)
println("Extend with Graphs.jl, CSV.jl, and DataFrames.jl for richer workflows.")
