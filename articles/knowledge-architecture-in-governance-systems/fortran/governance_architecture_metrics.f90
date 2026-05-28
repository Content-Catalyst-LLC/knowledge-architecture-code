program governance_architecture_metrics
  implicit none

  real :: objects
  real :: relationships

  objects = 14.0
  relationships = 15.0

  print *, "Governance Knowledge Architecture Metrics"
  print *, "Metadata coverage: ", 13.0 / objects
  print *, "Accountability context coverage: ", 11.0 / objects
  print *, "Equity context coverage: ", 9.0 / objects
  print *, "Relationship traceability: ", 14.0 / relationships
  print *, "Underspecified relationship risk: ", 1.0 / relationships
end program governance_architecture_metrics
