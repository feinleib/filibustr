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
