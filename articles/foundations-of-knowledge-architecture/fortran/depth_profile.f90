program depth_profile
  implicit none
  integer, dimension(12) :: depth
  integer :: i, max_depth, total
  real :: mean_depth

  depth = (/0, 1, 1, 1, 2, 1, 1, 2, 2, 2, 2, 2/)
  max_depth = maxval(depth)
  total = sum(depth)
  mean_depth = real(total) / real(size(depth))

  print *, 'Knowledge Architecture Depth Profile'
  print *, 'Concept count:', size(depth)
  print *, 'Max depth:', max_depth
  print *, 'Mean depth:', mean_depth

  do i = 1, size(depth)
    print *, 'Concept ', i, ' depth ', depth(i)
  end do
end program depth_profile
