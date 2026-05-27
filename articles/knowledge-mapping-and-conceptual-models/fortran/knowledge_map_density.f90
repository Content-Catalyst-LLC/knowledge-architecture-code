program knowledge_map_density
  implicit none
  integer :: concept_count, relationship_count
  real :: density

  concept_count = 9
  relationship_count = 9

  density = real(relationship_count) / real(concept_count * (concept_count - 1))

  print *, 'concept_count,', concept_count
  print *, 'relationship_count,', relationship_count
  print *, 'directed_density,', density
end program knowledge_map_density
