using Printf

objects = [
  (metadata=true, subject=true, rights=true, preservation=true),
  (metadata=true, subject=true, rights=false, preservation=true),
  (metadata=true, subject=true, rights=true, preservation=true),
  (metadata=true, subject=false, rights=true, preservation=true),
  (metadata=false, subject=false, rights=false, preservation=false),
  (metadata=true, subject=true, rights=true, preservation=true),
  (metadata=true, subject=false, rights=true, preservation=false),
  (metadata=true, subject=true, rights=true, preservation=false),
  (metadata=true, subject=false, rights=true, preservation=false),
  (metadata=true, subject=false, rights=true, preservation=true)
]

metadata_coverage = count(o -> o.metadata, objects) / length(objects)
subject_coverage = count(o -> o.subject, objects) / length(objects)
rights_coverage = count(o -> o.rights, objects) / length(objects)
preservation_coverage = count(o -> o.preservation, objects) / length(objects)
traceability = 11 / 12
quality_score = (metadata_coverage + subject_coverage + rights_coverage + preservation_coverage + traceability) / 5

mkpath(joinpath(@__DIR__, "..", "outputs"))
open(joinpath(@__DIR__, "..", "outputs", "julia_digital_library_quality_metrics.csv"), "w") do io
    println(io, "metric,value")
    @printf(io, "metadata_coverage,%.3f\n", metadata_coverage)
    @printf(io, "subject_coverage,%.3f\n", subject_coverage)
    @printf(io, "rights_coverage,%.3f\n", rights_coverage)
    @printf(io, "preservation_coverage,%.3f\n", preservation_coverage)
    @printf(io, "relationship_traceability,%.3f\n", traceability)
    @printf(io, "digital_library_quality_score,%.3f\n", quality_score)
end

println("Wrote Julia digital library quality metrics.")
