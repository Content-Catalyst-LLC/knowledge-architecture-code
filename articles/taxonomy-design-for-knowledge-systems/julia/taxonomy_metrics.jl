# Taxonomy metric exploration in Julia.
# Run from the article folder: julia julia/taxonomy_metrics.jl

using DelimitedFiles

function read_csv_lines(path)
    lines = readlines(path)
    header = split(lines[1], ",")
    rows = [split(line, ",") for line in lines[2:end]]
    return header, rows
end

header, rows = read_csv_lines("data/taxonomy_terms.csv")
depth_index = findfirst(==("depth"), header)
facet_index = findfirst(==("facet"), header)

depths = [parse(Int, row[depth_index]) for row in rows]
facets = [row[facet_index] for row in rows]

facet_counts = Dict{String, Int}()
for facet in facets
    facet_counts[facet] = get(facet_counts, facet, 0) + 1
end

mkpath("outputs")
open("outputs/julia_taxonomy_metrics.txt", "w") do io
    println(io, "term_count=$(length(rows))")
    println(io, "max_depth=$(maximum(depths))")
    println(io, "mean_depth=$(sum(depths) / length(depths))")
    println(io, "facet_counts=$(facet_counts)")
end

println("Wrote outputs/julia_taxonomy_metrics.txt")
