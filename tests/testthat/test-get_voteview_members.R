test_that("download from Voteview", {
  online_voteview_members <- get_voteview_members()
  expect_s3_class(online_voteview_members, "tbl_df")
  expect_length(online_voteview_members, 22)
  # floor on all-time members length
  expect_gt(nrow(online_voteview_members), 50400)
  expect_equal(levels(online_voteview_members$chamber),
               c("President", "House", "Senate"))
  expect_equal(unique(online_voteview_members$congress), 1:current_congress())
})

test_that("filter by chamber", {
  hr <- get_voteview_members(chamber = "house")
  expect_length(hr, 22)
  expect_equal(levels(hr$chamber), c("President", "House"))
  expect_equal(unique(hr$congress), 1:current_congress())

  s <- get_voteview_members(chamber = "senate")
  expect_length(s, 22)
  expect_equal(levels(s$chamber), c("President", "Senate"))
  expect_equal(unique(s$congress), 1:current_congress())

  expect_gt(nrow(hr), nrow(s))

  # TODO: how to correctly test for a warning? This still produces a warning in the test.
  # expect_warning(get_voteview_members(chamber = "not a chamber"),
  #                "Invalid `chamber` argument \\(\"not a chamber\"\\) provided\\. Using `chamber = \"all\"`\\.")
})

test_that("filter by congress", {
  members_110 <- get_voteview_members(congress = 110, chamber = "s")
  expect_s3_class(members_110, "tbl_df")
  expect_equal(levels(members_110$chamber),
               c("President", "Senate"))
  expect_equal(unique(members_110$congress), 110)

  members_1 <- get_voteview_members(congress = 1)
  expect_s3_class(members_1, "tbl_df")
  expect_equal(levels(members_1$chamber),
               c("President", "House", "Senate"))
  expect_equal(unique(members_1$congress), 1)

  sens_all_congresses <- get_voteview_members(congress = 200, chamber = "sen")
  expect_s3_class(sens_all_congresses, "tbl_df")
  expect_equal(levels(sens_all_congresses$chamber),
               c("President", "Senate"))
  expect_equal(unique(sens_all_congresses$congress), 1:current_congress())

  expect_gt(nrow(sens_all_congresses), nrow(members_110))

  members_90_95 <- get_voteview_members(congress = 90:95)
  expect_s3_class(members_90_95, "tbl_df")
  expect_equal(unique(members_90_95$congress), 90:95)
  expect_equal(levels(members_90_95$chamber),
               c("President", "House", "Senate"))
  expect_equal(nrow(members_90_95), 3276)
})

test_that("column types", {
  members_98 <- get_voteview_members(congress = 98)
  expect_s3_class(members_98, "tbl_df")
  expect_equal(nrow(members_98), 542)
  expect_length(members_98, 22)

  expect_length(dplyr::select(members_98, dplyr::where(is.double)), 6)
  expect_length(dplyr::select(members_98, dplyr::where(is.integer)), 11)
  expect_length(dplyr::select(members_98, dplyr::where(is.character)), 2)
  expect_length(dplyr::select(members_98, dplyr::where(is.factor)), 2)
  expect_length(dplyr::select(members_98, dplyr::where(is.logical)), 1)
})

test_that("local read/write", {
  # create filepaths
  tmp_csv <- tempfile(fileext = ".csv")
  tmp_tsv <- tempfile(fileext = ".tsv")
  tmp_dta <- tempfile(fileext = ".dta")

  # download data from online
  all_members_online <- get_voteview_members(chamber = "all")
  expect_s3_class(all_members_online, "tbl_df")
  expect_length(all_members_online, 22)
  expect_gt(nrow(all_members_online), 50400)
  readr::write_csv(all_members_online, tmp_csv)

  hr_117_online <- get_voteview_members(chamber = "hr", congress = 117)
  expect_s3_class(hr_117_online, "tbl_df")
  expect_length(hr_117_online, 22)
  expect_equal(nrow(hr_117_online), 457)
  haven::write_dta(hr_117_online, tmp_dta)

  s_70_73_online <- get_voteview_members(chamber = "s", congress = 70:73)
  expect_s3_class(s_70_73_online, "tbl_df")
  expect_length(s_70_73_online, 22)
  expect_equal(nrow(s_70_73_online), 425)
  readr::write_tsv(s_70_73_online, tmp_tsv)

  # check that local data matches
  all_members_local <- get_voteview_members(chamber = "all", read_from_local_path = tmp_csv)
  expect_s3_class(all_members_local, "tbl_df")
  expect_equal(all_members_local, all_members_online)

  hr_117_local <- get_voteview_members(chamber = "hr", congress = 117,
                                       read_from_local_path = tmp_dta)
  expect_s3_class(hr_117_local, "tbl_df")
  expect_equal(haven::zap_labels(haven::zap_formats(hr_117_local)), hr_117_online)
})
