program educational_knowledge_system_metrics
  implicit none

  real :: objects
  real :: relationships

  objects = 14.0
  relationships = 16.0

  print *, "Educational Knowledge System Metrics"
  print *, "Metadata coverage: ", 13.0 / objects
  print *, "Accessibility context coverage: ", 13.0 / objects
  print *, "Review context coverage: ", 12.0 / objects
  print *, "Relationship traceability: ", 15.0 / relationships
  print *, "Underspecified relationship risk: ", 1.0 / relationships
end program educational_knowledge_system_metrics
