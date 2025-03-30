## R CMD check results

0 errors | 0 warnings | 1 note

* checking CRAN incoming feasibility ... [13s] NOTE
Maintainer: 'Max Feinleib <mhfeinleib@gmail.com>'

New submission

Package was archived on CRAN

CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2024-07-19 for repeated policy violation.

  On Internet access.

> This release fixes issues I was having with the CRAN policy "Packages which 
  use Internet resources should fail gracefully," which led to this package 
  being archived.
  I have improved the error handling and I am now using `skip_if_offline()` in 
  tests that use Internet resources.

Found the following (possibly) invalid URLs:
  URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/EARLA4&version=1.0
    From: man/get_hvw_data.Rd
    Status: 202
    Message: Accepted

> I'm not sure if there's anything to do about this URL returning HTTP code 202.
  The link works as intended when you click on it.

