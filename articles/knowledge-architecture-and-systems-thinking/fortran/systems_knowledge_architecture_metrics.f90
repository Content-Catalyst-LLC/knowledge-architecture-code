program systems_knowledge_architecture_metrics
  implicit none

  real :: objects
  real :: relationships

  objects = 12.0
  relationships = 14.0

  print *, "Systems-Oriented Knowledge Architecture Metrics"
  print *, "Metadata coverage: ", 11.0 / objects
  print *, "Feedback role coverage: ", 8.0 / objects
  print *, "Relationship traceability: ", 13.0 / relationships
  print *, "Feedback edge share: ", 6.0 / relationships
  print *, "Underspecified relationship risk: ", 1.0 / relationships
end program systems_knowledge_architecture_metrics
