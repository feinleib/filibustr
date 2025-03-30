## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
* This release fixes issues I was having with the CRAN policy "Packages which 
  use Internet resources should fail gracefully," which led to this package 
  being archived. I have improved the error handling and I am now using 
  `skip_if_offline()` in tests that use Internet resources.
