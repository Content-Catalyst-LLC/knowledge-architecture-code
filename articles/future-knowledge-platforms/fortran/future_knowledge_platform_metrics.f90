program future_knowledge_platform_metrics
  implicit none

  real :: objects
  real :: relationships

  objects = 14.0
  relationships = 14.0

  print *, "Future Knowledge Platform Metrics"
  print *, "Metadata coverage: ", 13.0 / objects
  print *, "Provenance coverage: ", 12.0 / objects
  print *, "Reuse context coverage: ", 11.0 / objects
  print *, "Review context coverage: ", 11.0 / objects
  print *, "Relationship traceability: ", 13.0 / relationships
  print *, "Underspecified relationship risk: ", 1.0 / relationships
end program future_knowledge_platform_metrics
