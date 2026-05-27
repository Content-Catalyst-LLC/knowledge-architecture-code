program framework_summary
  implicit none
  integer :: total_elements
  integer :: documented_elements
  real :: coverage

  total_elements = 9
  documented_elements = 6

  coverage = real(documented_elements) / real(total_elements)

  print *, "Research framework element coverage:", coverage
end program framework_summary
