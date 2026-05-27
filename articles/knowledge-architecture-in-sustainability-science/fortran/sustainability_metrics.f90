program sustainability_metrics
  implicit none

  real :: objects
  real :: relationships

  objects = 10.0
  relationships = 11.0

  print *, "Sustainability Knowledge Architecture Metrics"
  print *, "Metadata coverage: ", 9.0 / objects
  print *, "Justice context coverage: ", 6.0 / objects
  print *, "Uncertainty context coverage: ", 8.0 / objects
  print *, "Relationship traceability: ", 10.0 / relationships
  print *, "Underspecified relationship risk: ", 1.0 / relationships
end program sustainability_metrics
