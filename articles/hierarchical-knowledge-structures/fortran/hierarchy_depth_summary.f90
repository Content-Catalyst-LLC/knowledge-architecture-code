program hierarchy_depth_summary
  implicit none

  integer, dimension(10) :: depths
  integer :: n, max_depth
  real :: mean_depth

  depths = (/0, 1, 1, 1, 2, 2, 2, 2, 2, 2/)
  n = size(depths)
  max_depth = maxval(depths)
  mean_depth = real(sum(depths)) / real(n)

  print *, "Fortran hierarchy depth summary"
  print *, "Node count: ", n
  print *, "Max depth: ", max_depth
  print *, "Mean depth: ", mean_depth
end program hierarchy_depth_summary
