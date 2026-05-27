# Research Framework Metrics in Julia
# Minimal standard-library style scaffold.

function parse_csv(path::String)
    lines = readlines(path)
    header = split(lines[1], ",")
    rows = Dict{String,String}[]
    for line in lines[2:end]
        values = split(line, ",")
        row = Dict{String,String}()
        for (key, value) in zip(header, values)
            row[key] = value
        end
        push!(rows, row)
    end
    return rows
end

elements = parse_csv("data/model_elements.csv")
relationships = parse_csv("data/model_relationships.csv")

roles = Dict{String,Int}()
statuses = Dict{String,Int}()

for row in elements
    roles[row["role"]] = get(roles, row["role"], 0) + 1
    statuses[row["evidence_status"]] = get(statuses, row["evidence_status"], 0) + 1
end

documented = count(row -> lowercase(row["documented"]) == "true", relationships)
total = length(relationships)
coherence = total == 0 ? 0.0 : documented / total

mkpath("outputs")
open("outputs/julia_framework_summary.txt", "w") do io
    println(io, "Research Framework Metrics")
    println(io, "element_count=$(length(elements))")
    println(io, "relationship_count=$total")
    println(io, "documented_relationships=$documented")
    println(io, "coherence_rate=$coherence")
    println(io, "roles=$roles")
    println(io, "statuses=$statuses")
end

println("Wrote outputs/julia_framework_summary.txt")
