test_that("HVW house data", {
  house_data <- get_hvw_data("house")

  # data checks
  expect_s3_class(house_data, "tbl_df")
  expect_length(house_data, 109)
  expect_equal(nrow(house_data), 9825)
  expect_equal(unique(house_data$congress), 93:114)
  expect_equal(unique(house_data$year), c(seq(1973, 2015, 2), NA))

  # check chamber argument
  expect_equal(house_data, get_hvw_data("h"))
  expect_equal(house_data, get_hvw_data("hr"))
})

test_that("HVW senate data", {
  senate_data <- get_hvw_data("senate")

  # data checks
  expect_s3_class(senate_data, "tbl_df")
  expect_length(senate_data, 104)
  expect_equal(nrow(senate_data), 2228)
  expect_equal(unique(senate_data$congress), 93:114)
  expect_equal(unique(senate_data$year), seq(1972, 2014, 2))

  # check chamber argument
  expect_equal(senate_data, get_hvw_data("s"))
  expect_equal(senate_data, get_hvw_data("sen"))
})

test_that("HVW chamber errors", {
  expect_error(get_hvw_data("all"))
  expect_error(get_hvw_data("congress"))
  expect_error(get_hvw_data(), "argument \"chamber\" is missing, with no default")
})

test_that("HVW local reading and writing", {
  ## create temp file paths
  tmp_csv <- tempfile(fileext = ".csv")
  tmp_tsv <- tempfile(fileext = ".tsv")
  tmp_tab <- tempfile(fileext = ".tab")
  tmp_dta <- tempfile(fileext = ".dta")

  ## download data from online
  sen_online <- get_hvw_data(chamber = "s", write_to_local_path = tmp_csv)
  expect_s3_class(sen_online, "tbl_df")
  expect_length(sen_online, 104)
  expect_equal(nrow(sen_online), 2228)
  expect_equal(unique(sen_online$congress), 93:114)
  expect_equal(unique(sen_online$year), seq(1972, 2014, 2))

  hr_online <- get_hvw_data(chamber = "hr", write_to_local_path = tmp_tsv)
  expect_s3_class(hr_online, "tbl_df")
  expect_length(hr_online, 109)
  expect_equal(nrow(hr_online), 9825)
  expect_equal(unique(hr_online$congress), 93:114)
  expect_equal(unique(hr_online$year), c(seq(1973, 2015, 2), NA))

  ## check that local data matches
  sen_local <- get_hvw_data("s", read_from_local_path = tmp_csv, write_to_local_path = tmp_tab)
  expect_s3_class(sen_local, "tbl_df")
  expect_equal(nrow(sen_local), 2228)
  expect_equal(sen_online, sen_local)

  hr_local <- get_hvw_data("hr", read_from_local_path = tmp_tsv, write_to_local_path = tmp_dta)
  expect_equal(hr_online, hr_local)

  ## test that re-written data matches
  sen_rewritten <- get_hvw_data("s", read_from_local_path = tmp_tab)
  expect_equal(sen_online, sen_rewritten)

  # TODO: fix these tests
  # issue has to do with .dta file attributes/labels and NA characters
  # writing house data in previous senate file
  # hr_rewritten <- get_hvw_data("hr", read_from_local_path = tmp_dta, write_to_local_path = tmp_csv)
  # expect_equal(hr_online, hr_rewritten)

  # hr_in_sen_file <- get_hvw_data("hr", read_from_local_path = tmp_csv)
  # expect_equal(hr_online, hr_in_sen_file)
})
