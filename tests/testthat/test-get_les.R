test_that("LES classic House data", {
  hr_classic <- get_les("house", les_2 = FALSE)

  # data checks
  expect_s3_class(hr_classic, "tbl_df")
  expect_length(hr_classic, 60)
  expect_equal(nrow(hr_classic), 11158)
  expect_equal(unique(hr_classic$congress), 93:117)
  expect_equal(unique(hr_classic$year), seq(1973, 2021, 2))

  # chamber argument
  expect_equal(hr_classic, get_les("hr", les_2 = FALSE))
})

test_that("LES classic Senate data", {
  s_classic <- get_les("senate", les_2 = FALSE)

  # data checks
  expect_s3_class(s_classic, "tbl_df")
  expect_length(s_classic, 60)
  expect_equal(nrow(s_classic), 2533)
  expect_equal(unique(s_classic$congress), 93:117)
  expect_equal(unique(s_classic$year), seq(1972, 2020, 2))

  # chamber argument
  expect_equal(s_classic, get_les("s", les_2 = FALSE))
})

test_that("LES 2.0 House data", {
  hr_2 <- get_les("hr", les_2 = TRUE)

  # data checks
  expect_s3_class(hr_2, "tbl_df")
  expect_length(hr_2, 60)
  expect_equal(nrow(hr_2), 454)
  expect_equal(unique(hr_2$congress), 117)
  expect_equal(unique(hr_2$year), 2021)

  # chamber argument
  expect_equal(hr_2, get_les("h", les_2 = TRUE))
})

test_that("LES 2.0 Senate data", {
  s_2 <- get_les("sen", les_2 = TRUE)

  # data checks
  expect_s3_class(s_2, "tbl_df")
  expect_length(s_2, 60)
  expect_equal(nrow(s_2), 100)
  expect_equal(unique(s_2$congress), 117)
  expect_equal(unique(s_2$year), 2020)

  # chamber argument
  expect_equal(s_2, get_les("s", les_2 = TRUE))
})

test_that("column types", {
  # Senate, LES Classic
  s_1 <- get_les("s", les_2 = FALSE)
  expect_s3_class(s_1, "tbl_df")
  expect_length(s_1, 60)
  expect_equal(nrow(s_1), 2533)
  expect_length(dplyr::select(s_1, dplyr::where(is.integer)), 33)
  expect_length(dplyr::select(s_1, dplyr::where(is.double)), 9)
  expect_length(dplyr::select(s_1, dplyr::where(is.factor)), 2)
  expect_length(dplyr::select(s_1, dplyr::where(is.character)), 4)
  expect_length(dplyr::select(s_1, dplyr::where(is.logical)), 12)

  # House, LES 2
  hr_2 <- get_les("hr", les_2 = TRUE)
  expect_s3_class(hr_2, "tbl_df")
  expect_length(hr_2, 60)
  expect_equal(nrow(hr_2), 454)
  expect_length(dplyr::select(hr_2, dplyr::where(is.integer)), 33)
  expect_length(dplyr::select(hr_2, dplyr::where(is.double)), 9)
  expect_length(dplyr::select(hr_2, dplyr::where(is.factor)), 2)
  expect_length(dplyr::select(hr_2, dplyr::where(is.character)), 3)
  expect_length(dplyr::select(hr_2, dplyr::where(is.logical)), 13)
})

test_that("LES local reading and writing", {
  ## create temp file paths
  tmp_csv <- tempfile(fileext = ".csv")
  tmp_tab <- tempfile(fileext = ".tab")
  tmp_tsv <- tempfile(fileext = ".tsv")
  tmp_dta <- tempfile(fileext = ".dta")

  ## download data from online
  s1_online <- get_les("s", les_2 = FALSE)
  expect_s3_class(s1_online, "tbl_df")
  readr::write_csv(s1_online, tmp_csv)

  h1_online <- get_les("hr", les_2 = FALSE)
  expect_s3_class(h1_online, "tbl_df")
  readr::write_tsv(h1_online, tmp_tab)

  s2_online <- get_les("s", les_2 = TRUE)
  expect_s3_class(s1_online, "tbl_df")
  readr::write_tsv(s2_online, tmp_tsv)

  h2_online <- get_les("hr", les_2 = TRUE)
  expect_s3_class(h1_online, "tbl_df")
  haven::write_dta(h2_online, tmp_dta)

  ## check that local data matches
  s1_local <- get_les("s", les_2 = FALSE, read_from_local_path = tmp_csv)
  expect_s3_class(s1_local, "tbl_df")
  expect_equal(s1_local, haven::zap_label(haven::zap_formats(s1_online)))

  h1_local <- get_les("hr", les_2 = FALSE, read_from_local_path = tmp_tab)
  expect_s3_class(h1_local, "tbl_df")
  expect_equal(h1_local, haven::zap_label(haven::zap_formats(h1_online)))

  s2_local <- get_les("s", les_2 = TRUE, read_from_local_path = tmp_tsv)
  expect_s3_class(s2_local, "tbl_df")
  expect_equal(s2_local, haven::zap_label(haven::zap_formats(s2_online)))

  h2_local <- get_les("hr", les_2 = TRUE, read_from_local_path = tmp_dta)
  expect_s3_class(h2_local, "tbl_df")
  # don't need to zap label/formats since we saved data in a DTA file
  expect_equal(h2_local, h2_online)

  ## test that re-written data matches
  readr::write_csv(h1_local, tmp_csv)
  h1_rewritten <- get_les("hr", les_2 = FALSE, read_from_local_path = tmp_csv)
  expect_s3_class(h1_rewritten, "tbl_df")
  expect_equal(h1_rewritten, h1_local)

  haven::write_dta(s2_local, tmp_dta)
  s2_rewritten <- get_les("s", les_2 = TRUE, read_from_local_path = tmp_dta)
  expect_s3_class(s2_rewritten, "tbl_df")
  expect_equal(haven::zap_formats(s2_rewritten), s2_local)
})
