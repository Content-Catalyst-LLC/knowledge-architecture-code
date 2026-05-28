program scientific_collaboration_metrics
  implicit none

  real :: objects
  real :: relationships

  objects = 14.0
  relationships = 16.0

  print *, "Scientific Collaboration Knowledge System Metrics"
  print *, "Metadata coverage: ", 13.0 / objects
  print *, "Provenance coverage: ", 13.0 / objects
  print *, "Review context coverage: ", 11.0 / objects
  print *, "Relationship traceability: ", 15.0 / relationships
  print *, "Underspecified relationship risk: ", 1.0 / relationships
end program scientific_collaboration_metrics
