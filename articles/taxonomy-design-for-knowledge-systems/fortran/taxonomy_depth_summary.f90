program taxonomy_depth_summary
  implicit none
  integer, dimension(11) :: depths
  integer :: i, max_depth, total
  real :: mean_depth

  depths = (/0,1,1,1,2,3,2,2,2,2,2/)
  max_depth = 0
  total = 0

  do i = 1, size(depths)
    if (depths(i) > max_depth) max_depth = depths(i)
    total = total + depths(i)
  end do

  mean_depth = real(total) / real(size(depths))

  print *, 'term_count=', size(depths)
  print *, 'max_depth=', max_depth
  print *, 'mean_depth=', mean_depth
end program taxonomy_depth_summary
