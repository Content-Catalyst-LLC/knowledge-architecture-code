program taxonomy_depth_summary
  implicit none

  integer, parameter :: n = 12
  integer :: depths(n)
  integer :: i, max_depth
  real :: mean_depth

  depths = (/ 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2 /)

  max_depth = depths(1)
  do i = 1, n
     if (depths(i) > max_depth) max_depth = depths(i)
  end do

  mean_depth = real(sum(depths)) / real(n)

  print *, "taxonomy_depth_summary"
  print *, "concept_count:", n
  print *, "max_depth:", max_depth
  print *, "mean_depth:", mean_depth
end program taxonomy_depth_summary
