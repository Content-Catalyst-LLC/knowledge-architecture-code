program ia_ka_metrics
  implicit none

  integer :: object_count
  real :: navigation_coverage
  real :: semantic_coverage
  real :: metadata_coverage

  ! Small fixed metrics for the synthetic dataset.
  object_count = 9
  navigation_coverage = 8.0 / 9.0
  semantic_coverage = 8.0 / 9.0
  metadata_coverage = 8.0 / 9.0

  print *, "IA/KA synthetic metric summary"
  print *, "Objects: ", object_count
  print *, "Navigation coverage: ", navigation_coverage
  print *, "Semantic coverage: ", semantic_coverage
  print *, "Metadata coverage: ", metadata_coverage
end program ia_ka_metrics
